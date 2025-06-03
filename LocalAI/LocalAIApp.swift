//
//  LocalAIApp.swift
//  LocalAI
//
//  Created by Michele Manniello on 27/04/25.
//

import SwiftUI
import AppKit

@main
struct LocalAIApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("pythonPath") var pythonPathData = ""
    var body: some Scene {
        WindowGroup {
            if(pythonPathData.isEmpty) {
                WelcomeScreen()
            } else {
                ContentView()
            }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            CommandGroup(replacing: .appSettings) {
                Button("Impostazioni"){
                    appDelegate.showWindow()
                }
                .keyboardShortcut(",",modifiers: .command)
            }
        }
    }
}

class AppDelegate: NSObject,NSApplicationDelegate {
    var settingsWindow: NSWindow!
    
    func showWindow() {
        let height: Double = 400
        let width: Double = 400
        
        if settingsWindow == nil {
            let settingsView = SettingsView(width: width, height: height)
            settingsWindow = NSWindow(
                            contentRect: NSRect(x: 0, y: 0, width: width, height: height),
                            styleMask: [.titled, .closable,.fullSizeContentView],
                            backing: .buffered,
                            defer: false
                        )
            settingsWindow.center()
            settingsWindow.title = "Impostazioni"
            settingsWindow.titlebarAppearsTransparent = true
            settingsWindow.titleVisibility = .visible
            settingsWindow.isMovableByWindowBackground = true
            settingsWindow.contentView = NSHostingView(rootView: settingsView)
          
        }
        settingsWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
