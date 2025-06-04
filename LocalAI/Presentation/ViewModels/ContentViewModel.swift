//
//  ContentViewModel.swift
//  LocalAI
//
//  Created by Michele Manniello on 17/05/25.
//

import Foundation
import SwiftUI
import PythonKit
import AVKit

@Observable class ContentViewModel {
    
    let pythonRunner = PythonRun()
    var statusLoading = ""
    var isLoading = false
    var textAI = ""
    var textRequest = ""
    let coordinator: AppCordinatorProtocol
    var animatedText = AttributedString()
    var listModel: [AIInternalModel] = []
    var textAiColor: String {
        get { UserDefaults.standard.string(forKey: "textAIColor") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "textAIColor") }
    }
    var selectedAIModel: AIInternalModel?
    var voices: [AVSpeechSynthesisVoice] = []
    private let synthesizer = AVSpeechSynthesizer()
    var voiceSelected: AVSpeechSynthesisVoice?
    
    init(coordinator: AppCordinatorProtocol) {
        self.coordinator = coordinator
        self.voiceSelected = AVSpeechSynthesisVoice(identifier: "com.apple.voice.enhanced.it-IT.Luca")
        startPython()
    }
    
    func startPython()  {
        isLoading = true
        Task.detached(priority: .userInitiated){[weak self] in
            guard let self = self else {return }
            
            if let running =  self.pythonRunner.checkOllama(),  !self.pythonRunner.isTrue(running) {
                await MainActor.run {
                    self.statusLoading = "Avio Ollama....."
                }
                _ =  self.pythonRunner.startOllama()
                
                while true {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    let status = self.pythonRunner.checkOllama() ?? PythonObject(false)
                    if self.pythonRunner.isTrue(status) {
                        await MainActor.run {
                            self.statusLoading = "Ollama attivo!"
                            self.isLoading = false
                        }
                        break // Esce dal loop quando attivo
                    }
                    
                    await MainActor.run {
                        self.statusLoading = "Attesa attivazione Ollama (\(Date().formatted()))"
                        self.isLoading = false
                    }
                    
                }
            } else {
                await MainActor.run {
                    self.statusLoading = "Attesa attivazione Ollama (\(Date().formatted()))"
                    self.isLoading = false
                }
            }
        }
       
    }
    
     func callAI() {
      
         guard let selectedAIModel = self.selectedAIModel,
         let nameModel = selectedAIModel.nameModel else {
            
             statusLoading = "Modello Non Selezionato"
             isLoading = false
             textAI = ""
             
             return
         }
         
        statusLoading = "Controllo Ollama..."
        isLoading = true
        textAI = ""

        Task.detached(priority: .userInitiated) {
            [weak self] in
                guard let self = self else {return }
            if let running =  self.pythonRunner.checkOllama(),  !self.pythonRunner.isTrue(running) {
                await MainActor.run {
                    self.statusLoading = "Avio Ollama....."
                }
                _ =  self.pythonRunner.startOllama()
                var attempts = 0
                while attempts < 10 {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    if  self.pythonRunner.isTrue(pythonRunner.checkOllama() ?? PythonObject(false)) {
                                break
                            }
                    attempts += 1
                }
            }
            
            await MainActor.run {
                self.statusLoading = "Sto pensando....."
            }

            
            let response = await pythonRunner.callOllama(aiModelName: nameModel ,prompt: textRequest)
            let resultText = response?.description ?? "Errore: nessuna risposta"

            await MainActor.run {
                self.textAI = resultText
                self.textRequest = ""
                self.isLoading = false
               
                self.prepareInitialText()
                self.coordinator.handleSpeech(text: resultText, voice: self.voiceSelected)
//                speechText(text: resultText)
            }
        }
    }
    
     func prepareInitialText() {
        animatedText = AttributedString(textAI)
    }
    
    
     func updateAnimatedText() {
            var newText = AttributedString(textAI)
        let spokenRanges =  coordinator.speechManager.spokenWordRanges
            
            // Applica gradiente di colore alle parole pronunciate
            for (_, range) in spokenRanges.enumerated() {
                if let swiftRange = Range(range, in: newText) {
                    let color = NSColor(
                        hue: 0.6,
                        saturation: 0.8,
                        brightness: 0.8,
                        alpha: 1)
                    
                    newText[swiftRange].foregroundColor = Color(hex: textAiColor) ?? Color(color)
                    newText[swiftRange].font = .system(size: 20, weight: .bold)
                }
            }
            
            withAnimation(.easeInOut(duration: 0.2)) {
                animatedText = newText
            }
        }
    
    func loadLocalModels() {
        Task {
           let coreTerminal = CoreTerminal()
            let models = await coreTerminal.ollamaListModel() ?? ""
            
            await MainActor.run {
//                self.listModel = models
                let row = models.split(separator: "\n").map({  String($0) })
                
                
                var aiModel =  row.map ({ AIInternalModel(row: $0,header:row.first)})
                
                aiModel.removeFirst()
                let setAIModel = Set(aiModel)
                self.listModel = Array(setAIModel)
            }
        }
    }
    
    
     func loadVoci() {
//        let synthesizer = AVSpeechSynthesizer() // Unica istanza condivisa
        self.voices = AVSpeechSynthesisVoice.speechVoices().filter {
            $0.language == "it-IT"
        }
        voices.forEach { v in
            if(v.language == "it-IT") {
                print("Lingua: \(v.language), Nome: \(v.name), Identificatore: \(v.identifier)")
            }
        }
        
        
       
        /*
        for (index, voice) in voices.enumerated() {
            // Aggiungi un ritardo tra una voce e l'altra
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 3.0) {
                let phrase = "Ciao sono \(voice.name.replacingOccurrences(of: " (Premium)", with: "")). Sono qui per parlare e leggere i messaggi."
                let utterance = AVSpeechUtterance(string: phrase)
                utterance.voice = voice
                
                // Configurazione ottimale
                utterance.rate = 0.5
                utterance.pitchMultiplier = 1.0
                utterance.volume = 0.8
                
                // Controllo aggiuntivo sulla compatibilità
                if AVSpeechSynthesisVoice.speechVoices().contains(where: { $0.identifier == voice.identifier }) {
                    print("Test voce: \(voice.name)")
                    synthesizer.speak(utterance)
                } else {
                    print("Voce \(voice.name) non disponibile")
                }
            }
        }
         */
    }
    
    func speachVoice(voice: AVSpeechSynthesisVoice) {
        let phrase = "Ciao sono \(voice.name.replacingOccurrences(of: " (Premium)", with: "")). Sono qui per parlare e leggere i messaggi."
        let utterance = AVSpeechUtterance(string: phrase)
        utterance.voice = voice
        
        // Configurazione ottimale
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0
        utterance.volume = 0.8
        
        // Controllo aggiuntivo sulla compatibilità
        print("Test voce: \(voice.name)")
        DispatchQueue.global(qos: .utility).async {
            self.synthesizer.speak(utterance)
        }
    }
}
