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
                    
                    CustomButton(falseColor: element.getColor) {
                        navigationRoute = element
                    } label: {
                        Text(element.name)
                    }

                }
            }
        }, detail: {
            switch navigationRoute {
            case .AIChat:
                HomeView()
                    .environment(speechToTextViewModel)
                    .environment(contentViewModel)
            case .Impostazioni:
                Text("Impostazioni")
            case .Voices:
                Text("Voices")
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
    case Impostazioni
    case Voices
    
    
    var name: String {
        switch self {
        case .AIChat:
            return "AIChat"
        case .Impostazioni:
            return "Impostazioni"
        case .Voices:
            return "Voices"
        }
    }
    
    var getColor: Color {
        switch self {
        case .AIChat:
            Color.green
        case .Impostazioni:
            Color.pink
        case .Voices:
            Color.orange
        }
    }
    
    
}
