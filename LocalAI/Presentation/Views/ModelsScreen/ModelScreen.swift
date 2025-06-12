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
        VStack(alignment: .leading, spacing: 20) {
            TitleView(title: "I Tuoi Modelli AI")
            
            Text("Clicca per selezionare l'AI da usare")
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            ScrollView {
             
            VStack(alignment: .leading, spacing: 12) {
                ForEach(contentViewModel.listModel, id: \.Uid) { model in
                    Button(action: {
                        contentViewModel.selectedAIModel = model
                    }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(model.name ?? "Modello senza nome")
                                .font(.headline)
                                .foregroundColor(.white)

                            HStack {
                                Text("📦 \(model.size ?? "N/A")")
                                Spacer()
                                Text("🗓 \(model.modified ?? "Data sconosciuta")")
                            }
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    contentViewModel.selectedAIModel == model
                                    ? LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    : LinearGradient(
                                        gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .shadow(color: contentViewModel.selectedAIModel == model ? Color.purple.opacity(0.4) : Color.clear, radius: 6, x: 0, y: 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
                
            }
        }
        .padding(.top)
        .onAppear {
            contentViewModel.loadLocalModels()
        }
    }

}

#Preview {
    ModelScreen()
        .environment(ContentViewModel(coordinator: AppCordinator()))
        .frame(width: 500, height: 600)
}
