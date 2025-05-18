//
//  SpeechTextProtocol.swift
//  LocalAI
//
//  Created by Michele Manniello on 04/05/25.
//

import Foundation

protocol SpeechToTextServiceProtocol {
    func authorize() async throws
    func transcribe() -> AsyncThrowingStream<String, Error>
    func stopTranscribing()
}
