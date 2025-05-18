//
//  ErrorSpeech.swift
//  LocalAI
//
//  Created by Michele Manniello on 04/05/25.
//

import Foundation

enum RecognizerError: Error {
    case recognizerUnavailable
    case notAuthorizedToRecognize
    case notPermittedToRecord
    
    
}
