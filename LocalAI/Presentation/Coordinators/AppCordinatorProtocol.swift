//
//  AppCordinatorProtocol.swift
//  LocalAI
//
//  Created by Michele Manniello on 17/05/25.
//

import Foundation
import SwiftUI
import AVKit

protocol AppCordinatorProtocol: AnyObject {
    var speechManager: SpeechManager { get }
    func handleSpeech(text:String, voice: AVSpeechSynthesisVoice?)
    
}


@Observable class AppCordinator: AppCordinatorProtocol {
    var speechManager = SpeechManager()
    
    func handleSpeech(text: String,voice: AVSpeechSynthesisVoice?) {
        let utterance = AVSpeechUtterance(string: text)
        if let voiceCheck = voice  {
            utterance.voice = voiceCheck
        } else if let voice =  AVSpeechSynthesisVoice(identifier: "com.apple.voice.enhanced.it-IT.Luca") {
            utterance.voice = voice
        }
      
        utterance.rate = 0.48
        utterance.pitchMultiplier = 1.15
        utterance.preUtteranceDelay = 0.2
        utterance.postUtteranceDelay = 0.3
        self.speechManager.speak(utterance: utterance)
    }
    
}
