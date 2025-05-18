//
//  SpeechToTextServices.swift
//  LocalAI
//
//  Created by Michele Manniello on 04/05/25.
//

import Foundation
import Speech
import AVFoundation

class SpeechToTextServices: @preconcurrency SpeechToTextServiceProtocol {
   

    private var recognizer: SFSpeechRecognizer?
    private var task: SFSpeechRecognitionTask?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var audioEngine: AVAudioEngine?
    private var accumulatedText: String = ""
    
    init(localeIdentifier: String = Locale.current.identifier) {
        
         let langCode = "it"
        let localeId = "\(langCode)-IT"
        self.recognizer = SFSpeechRecognizer(locale: Locale(identifier: localeId))
    }
    
    deinit {
        reset()
    }
    
    func authorize() async throws {
        guard self.recognizer != nil else {
            throw RecognizerError.recognizerUnavailable
        }
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { _ in
                continuation.resume()
            }
        }
        let status = SFSpeechRecognizer.authorizationStatus()
        
        // Determine if authorization is granted
        let hasAuthorization = (status == .authorized)
        guard hasAuthorization else {
            throw RecognizerError.notAuthorizedToRecognize
        }
        
        let isAuthorized = checkMicrophonePermission()
        if !isAuthorized {
            let granted = await requestMicrophoneAccess()
            guard granted else {
                throw RecognizerError.notPermittedToRecord
            }
        }
    }
    
    private func checkMicrophonePermission() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        return status == .authorized
    }

   private  func requestMicrophoneAccess() async -> Bool {
        await withCheckedContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                continuation.resume(returning: granted)
            }
        }
    }
    
    @MainActor
    func transcribe() -> AsyncThrowingStream<String,Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    let (audioEngine, request) = try Self.prepareEngine()
                    self.audioEngine = audioEngine
                    self.request = request
                    guard let recognizer = self.recognizer else {
                            throw RecognizerError.recognizerUnavailable
                    }
                    self.task = recognizer.recognitionTask(with: request) { [weak self] result, error in
                        guard let self = self else {
                            return
                        }
                        if let error = error {
                            continuation.finish(throwing: error)
                            self.reset()
                            return
                        }
                        
                        if let result = result {
                            let newText = result.bestTranscription.formattedString
                            continuation.yield(self.accumulatedText + newText)
                            
                            if result.speechRecognitionMetadata != nil {
                                self.accumulatedText += newText + ""
                            }
                            
                            if result.isFinal {
                                continuation.finish()
                                self.reset()
                            }
                        }
                    }
                    
                }catch {
                    continuation.finish(throwing: error)
                    self.reset()
                }
            }
        }
    }
    
    func reset() {
        task?.cancel()
        task = nil
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        accumulatedText = ""
    }
    
    
    func stopTranscribing() {
        reset()
    }
    
    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
            let audioEngine = AVAudioEngine()
            let request = SFSpeechAudioBufferRecognitionRequest()
            request.addsPunctuation = true
            request.taskHint = .dictation
            request.shouldReportPartialResults = true
            
            
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                request.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            return (audioEngine, request)
        }
    
    
}
