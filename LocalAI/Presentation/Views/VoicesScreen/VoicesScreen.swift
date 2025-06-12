//
//  VoicesScreen.swift
//  LocalAI
//
//  Created by Michele Manniello on 04/06/25.
//

import SwiftUI

struct VoicesScreen: View {
    @Environment(ContentViewModel.self) var contentViewModel
    @Namespace var selectionAnimation
    @State private var heights: [CGFloat] = [10, 14, 8]
    let barCount = 3
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            TitleView(title: "Elenco voci presenti nel MAC")

            Text("""
                Per scaricare altre voci:
                 > Impostazioni di Sistema
                Seleziona Accessibilità
                Vai su Contenuto letto ad alta voce o Voce
                Clicca su Voce di sistema → Gestisci voci
                """)
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.horizontal)


            ScrollView {
                VStack(spacing: 15) {
                    ForEach(contentViewModel.voices, id: \.identifier) { voice in
                        HStack(spacing: 12) {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    contentViewModel.speachVoice(voice: voice)
                                }
                            }) {
                                HStack {
                                    Image(systemName: "play.circle.fill")
                                        .foregroundColor(.white)
                                        .scaleEffect(1.1)
                                        .shadow(radius: 2)
                                    
                                    Text("\(voice.language) - \(voice.name)")
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                    if contentViewModel.voiceId == voice.identifier {
                                        HStack(spacing: 3) {
                                            ForEach(0..<barCount, id: \.self) { i in
                                                Capsule()
                                                    .fill(Color.white.opacity(0.9))
                                                    .frame(width: 3, height: heights[i])
                                            }
                                        }
                                        .frame(height: 20)
                                        .onAppear {
                                            animateBars()
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .frame(minWidth:150, maxWidth: 200)
                                .background(
                                    ZStack {
                                        
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color.pink, Color.purple]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                        //                                            .matchedGeometryEffect(id: "background_selection", in: selectionAnimation)
                                        
                                    }
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(radius: contentViewModel.voiceSelected?.identifier == voice.identifier ? 8 : 4)
                                .scaleEffect(contentViewModel.voiceSelected?.identifier == voice.identifier ? 1.05 : 1.0)
                                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: contentViewModel.voiceSelected?.identifier)
                                
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    contentViewModel.voiceSelected = voice
                                }
                            }) {
                                Text(contentViewModel.voiceSelected?.identifier == voice.identifier ? "✅ Selezionato" : "Seleziona")
                                    .font(.subheadline)
                                    .foregroundColor(contentViewModel.voiceSelected?.identifier == voice.identifier ? .green : .primary)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(contentViewModel.voiceSelected?.identifier == voice.identifier ? Color.green : Color.gray, lineWidth: 1)
                                            .animation(.easeInOut(duration: 0.3), value: contentViewModel.voiceSelected?.identifier)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .transition(.scale)
                        }
                        .padding(.horizontal, 4)
                    }
                }
                .padding(.horizontal)
            }

        }
        .padding(.top)

        .onAppear {
            contentViewModel.loadVoci()
        }
    }
    
    private func animateBars() {
            Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.25)) {
                    heights = heights.map { _ in CGFloat.random(in: 6...18) }
                }
            }
        }
}

#Preview {
    VoicesScreen()
        .environment(ContentViewModel(coordinator: AppCordinator()))
        .frame(width: 500, height: 700)
}
