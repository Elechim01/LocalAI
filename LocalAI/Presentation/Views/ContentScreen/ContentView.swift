//
//  ContentView.swift
//  LocalAI
//
//  Created by Michele Manniello on 27/04/25.
//

import SwiftUI
import AppKit

struct ContentView: View {

    @State
    private var speechToTextViewModel = SpeechToTextViewModel(speechToTextService:SpeechToTextServices())
       
    @State private var contentViewModel = ContentViewModel(coordinator: AppCordinator())
    @State private var columnvisibility = NavigationSplitViewVisibility.all
    @State private var navigationRoute: NavigationRoute = .AIChat
    
    
    
    var body: some View {
            NavigationSplitView(columnVisibility: $columnvisibility,sidebar: {
                VStack(alignment: .leading) {
                    List(NavigationRoute.allCases,id:\.hashValue) { element in
                        
                        CustomButton(isSelected: .constant(navigationRoute == element),
                                     imageName: element.image,
                                     titleButton: element.name) {
                            navigationRoute = element
                        }
                    }
                }
            }, detail: {
                switch navigationRoute {
                case .AIChat:
                    HomeView()
                        .environment(speechToTextViewModel)
                        .environment(contentViewModel)
                case .ModelliAI:
                  ModelScreen()
                        .environment(contentViewModel)
                case .Voices:
                    VoicesScreen()
                        .environment(contentViewModel)
                }
            })
            .navigationSplitViewStyle(.balanced)
        
    }

}


#Preview {
    ContentView()
}

enum NavigationRoute: CaseIterable {
    case AIChat
    case ModelliAI
    case Voices
    
    
    var name: String {
        switch self {
        case .AIChat:
            return "AIChat"
        case .ModelliAI:
            return "Modelli"
        case .Voices:
            return "Voices"
        }
    }
    
    var image: String {
        switch self {
        case .AIChat:
            return "brain"
        case .ModelliAI:
            return "square.stack.3d.up"
        case .Voices:
            return "waveform"
        }
    }
}
