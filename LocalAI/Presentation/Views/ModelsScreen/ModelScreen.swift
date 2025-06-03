//
//  ModelScreen.swift
//  LocalAI
//
//  Created by Michele Manniello on 02/06/25.
//

import SwiftUI

struct ModelScreen: View {
    
    @Environment(ContentViewModel.self) var contentViewModel
    
    var body: some View {
        VStack() {
            Text("I Tuoi Modelli AI")
                .font(.title)
                .padding()
         
            Text("Clicca per selezionare l'AI da usare")
                .font(.body)
                .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                
                ForEach(contentViewModel.listModel,id:\.Uid) { model in
                    Button {
                        contentViewModel.selectedAIModel = model
                    } label: {
                        HStack {
                            
                            Text("Name: \(model.name ?? "" )")
                            
                            Text("Size: \(model.size ?? "")")
                            
                            Text("Modified: \(model.modified ?? "")")
                        }
                    }
                    .background(content: {
                        contentViewModel.selectedAIModel == model ? Color.blue : Color.clear
                    })
                    

                   
                }
            }
        }
        .onAppear {
            contentViewModel.loadLocalModels()
        }
    }
}

#Preview {
    ModelScreen()
        .environment(ContentViewModel(coordinator: AppCordinator()))
        .frame(width: 500, height: 400)
}
