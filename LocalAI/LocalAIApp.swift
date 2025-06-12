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
                ZStack {
                BackgroundAuroraView()
                    WelcomeScreen()
                }
            } else {
                ZStack {
                    AnimatedBackground()
                    ContentView()
                }   
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

struct AnimatedBackground: View {
    @State private var animate = false

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                animate
                    ? Color(red: 50/255, green: 100/255, blue: 90/255)   // verde bottiglia soft
                    : Color(red: 40/255, green: 90/255, blue: 80/255),   // verde-blu scuro
                animate
                    ? Color(red: 40/255, green: 80/255, blue: 120/255)   // blu fumo
                    : Color(red: 30/255, green: 70/255, blue: 110/255)   // blu notte chiaro
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animate)
        .onAppear {
            animate.toggle()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct BackgroundAuroraView: View {
    @State private var animate = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.2, green: 0.6, blue: 0.4),
                        Color(red: 0.2, green: 0.4, blue: 0.6)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.08),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 300
                        )
                    )
                    .frame(width: 300, height: 300)
                    .offset(x: animate ? geo.size.width * 0.6 : geo.size.width * 0.1,
                            y: animate ? geo.size.height * 0.2 : geo.size.height * 0.6)
                    .onAppear { animate = true }
                    .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animate)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

