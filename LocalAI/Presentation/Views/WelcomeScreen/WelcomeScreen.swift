//
//  WelcomeScreen.swift
//  LocalAI
//
//  Created by Michele Manniello on 02/06/25.
//

import SwiftUI

#warning("Upgrade UI with animation")
struct WelcomeScreen: View {
    @AppStorage("pythonPath") var pythonPathData = ""
    var body: some View {
        VStack {
            Text("Benvenuto in LocalAI")
                .font(.title)
                .padding()
            
            Text("Per prima cosa inserisci il path di python in modo da poter far funzionare l'app")
            
            TextField("Path Python", text: $pythonPathData)
                .padding(.horizontal)
            
            Text("Puoi modificare il path dentro le impostazioni LocalAI -> Impostazioni")
        }
        .frame(width: 500, height: 400)
        
    }
}

#Preview {
    WelcomeScreen()
}
