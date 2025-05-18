//
//  SpeechToTextViewModel.swift
//  LocalAI
//
//  Created by Michele Manniello on 04/05/25.
//

import SwiftUI
import Foundation

 @Observable final class SpeechToTextViewModel {
    var transcript: String = ""
    var isRecording = false
    var errorMessage: String?
    
    private let speechToTextService: SpeechToTextServices
    private var transiscriptionTask: Task<Void, Never>?
    
    init(speechToTextService: SpeechToTextServices) {
        self.speechToTextService = speechToTextService
    }
    
    @MainActor
    func startRecording() {
        guard !isRecording else {
            return
        }
        
        isRecording = true
        
        transiscriptionTask = _Concurrency.Task {
            do {
                try await speechToTextService.authorize()
                let stream = speechToTextService.transcribe()
                for try await partialResult in stream {
                    self.transcript = partialResult
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    
    @MainActor
    func stopRecording() {
        guard isRecording else {
            return
        }
        
        isRecording = false
        transiscriptionTask?.cancel()
        transiscriptionTask = nil
        speechToTextService.stopTranscribing()
    }
    
}
