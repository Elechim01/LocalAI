//
//  CoreTerminal.swift
//  LocalAI
//
//  Created by Michele Manniello on 13/05/25.
//

import Foundation
import AppKit

class CoreTerminal {
  private func runCommand(_ command: String, arguments: [String] = []) async -> String?  {
        
        let process = Process()
        process.launchPath = "/bin/zsh"
        process.arguments = ["-c","\(command) \(arguments.joined(separator: " "))"]
        
        var env = ProcessInfo.processInfo.environment
        env["PATH"] =  "/usr/local/bin:" + (env["PATH"] ?? "")
        process.environment = env
      
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        process.launch()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            return output
        }
        return nil
    }
    
    func ollamaListModel() async -> String?  {
        return await runCommand("ollama list")
    }
 
}
