//
//  SpeechManager.swift
//  LocalAI
//
//  Created by Michele Manniello on 10/05/25.
//

import Foundation
import AVKit
@Observable class SpeechManager: NSObject, AVSpeechSynthesizerDelegate {
    
       var spokenWordRanges: [NSRange] = []
       private let synthesizer: AVSpeechSynthesizer
       private var currentUtterance: AVSpeechUtterance?
       
       init(synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()) {
           self.synthesizer = synthesizer
           super.init()
           self.synthesizer.delegate = self
       }
    
    func speak(utterance: AVSpeechUtterance) {
        currentUtterance = utterance
        spokenWordRanges.removeAll()
        DispatchQueue.global(qos: .utility).async {
            self.synthesizer.speak(utterance)
        }
       
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.spokenWordRanges.append(characterRange)
        }
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("Finish")
    }
    
    
}
