//
//  RunPython.swift
//  LocalAI
//
//  Created by Michele Manniello on 27/04/25.
//

import Foundation
import PythonKit

class PythonRun: PythonRunProtocol {
    private let file: PythonObject?
//    Nome AI
     var assistantName: String = "assistente"
   

    init() {
//        "/Users/michelemanniello/.pyenv/versions/3.10.12/lib/libpython3.10.dylib"
        let pythonPathData = UserDefaults.standard.string(forKey: "pythonPath") ?? ""
        setenv("PYTHON_LIBRARY",pythonPathData ,1)
        setenv("PYTHON_LOADER_LOGGING", "TRUE", 1)
        setenv("PYTHONIOENCODING", "utf-8", 1)
        setenv("LC_ALL", "it_IT.UTF-8", 1)
        
        let sys = Python.import("sys")
//        sys.path.append("/Users/michelemanniello/Documents/Sviluppo/Swift/LocalAI/LocalAI/Core/PythonAI")
        // Gestire il fatto che resourcePath sia null e bloccare l'app.
        
        
        sys.path.append(Bundle.main.resourcePath ?? "")
     
        
        self.file = Python.import("PythonCode")
    }

    func callOllama(aiModelName: String,prompt: String) async -> PythonObject? {
        return file?.call_ai(aiModelName,prompt)
    }

    func checkOllama() -> PythonObject? {
        return file?.is_ollama_running()
    }

    func startOllama() -> PythonObject? {
        return file?.start_ollama()
    }

    func isTrue(_ obj: PythonObject) -> Bool {
        return obj.description == "True"
    }
    
   
}

