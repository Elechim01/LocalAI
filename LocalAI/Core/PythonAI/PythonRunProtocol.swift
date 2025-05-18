//
//  PythonRunProtocol.swift
//  LocalAI
//
//  Created by Michele Manniello on 17/05/25.
//

import Foundation
import PythonKit

protocol PythonRunProtocol {
    func checkOllama() -> PythonObject?
    func startOllama() -> PythonObject?
    func isTrue(_ obj: PythonObject) -> Bool
    var assistantName: String { get set }
    
}
