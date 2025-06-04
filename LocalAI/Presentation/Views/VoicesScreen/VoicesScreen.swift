//
//  VoicesScreen.swift
//  LocalAI
//
//  Created by Michele Manniello on 04/06/25.
//

import SwiftUI

struct VoicesScreen: View {
    @Environment(ContentViewModel.self) var contentViewModel
    var body: some View {
        VStack {
            Text("Elenco voci presenti nel MAC")
                .font(.title)
            
            Text("Per scaricare altre voci:\n > Impostazioni di Sistema\nSeleziona Accessibilità\nVai su Contenuto letto ad alta voce o Voce\nClicca su Voce di sistema → Gestisci voci")
                .font(.body)
                .padding()
            
            VStack(alignment: .leading) {
                ForEach(contentViewModel.voices, id:\.identifier) { voice in
                    HStack {
                        
                   
                    Button {
                        contentViewModel.speachVoice(voice: voice)
                    } label: {
                        Text("Lingua: \(voice.language), Nome: \(voice.name)")
                    }
                    Button {
                        contentViewModel.voiceSelected = voice
                    } label: {
                        if(contentViewModel.voiceSelected?.identifier == voice.identifier) {
                            Text("Selezionato")
                        } else {
                            Text("Non selezionato")
                        }
                     
                    }
                    }


                }
            }
            .padding()
        }
        .onAppear {
            contentViewModel.loadVoci()
        }
    }
}

#Preview {
    VoicesScreen()
        .environment(ContentViewModel(coordinator: AppCordinator()))
        .frame(width: 500, height: 600)
}
