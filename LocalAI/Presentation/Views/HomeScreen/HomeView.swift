//
//  HomeView.swift
//  LocalAI
//
//  Created by Michele Manniello on 17/05/25.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(ContentViewModel.self) var contentViewModel
    @Environment(SpeechToTextViewModel.self) var speechToTextViewModel
    
    var body: some View {
        @Bindable var model = contentViewModel
        VStack(spacing: 16) {
            // Aggiungi la vista SpeechToTextView con il binding
            SpeechToTextView(transcript: $model.textRequest, nameAI: model.selectedAIModel?.nameModel ?? "")
                .environment(speechToTextViewModel)
                .frame(height: 250)
                // Altezza personalizzabile
            
           /* TextField("Text per AI", text: $model.textRequest)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            */
            
            HStack {
                Button(action: toggleRecord) {
                    HStack {
                        Image(systemName: speechToTextViewModel.isRecording ? "stop.fill" : "mic.fill")
                        Text(speechToTextViewModel.isRecording ? "Stop" : "Start")
                        
                    }
                    .padding()
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                .background(
                    speechToTextViewModel.isRecording ? Layout.RecordButton.stopRecordingColor : Layout.RecordButton.startRecordingColor
                )
                .cornerRadius(Layout.RecordButton.cornerRadius)
                
            
            Button(action: {
                guard !contentViewModel.textRequest.isEmpty, !speechToTextViewModel.isRecording else { return }
                self.contentViewModel.callAI()
            }) {
                HStack {
                    
                    Text(contentViewModel.isLoading ? contentViewModel.statusLoading : "Invia alla AI")
                }
                .padding()
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            .background(Color.pink)
            .cornerRadius(10)
            .disabled(contentViewModel.textRequest.isEmpty || contentViewModel.isLoading || speechToTextViewModel.isRecording)
            }
            
            if contentViewModel.isLoading {
                ProgressView()
            }
            
            ScrollView {
                Text(contentViewModel.animatedText)
                    .font(.system(size: 20, weight: .regular, design: .rounded))
                    .multilineTextAlignment(.leading)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .onAppear(perform: contentViewModel.prepareInitialText)
            .onChange(of: contentViewModel.coordinator.speechManager.spokenWordRanges, { oldValue, newValue in
                withAnimation(.easeIn(duration: 0.1)) {
                    contentViewModel.updateAnimatedText()
                }
               
            })
            .frame(maxHeight: .infinity)
        }
        .padding()
    }
    
    private func toggleRecord() {
        if speechToTextViewModel.isRecording {
            speechToTextViewModel.stopRecording()
        } else {
            speechToTextViewModel.startRecording()
        }
    }
    
}

#Preview {
    HomeView()
        .environment(SpeechToTextViewModel(speechToTextService:SpeechToTextServices()))
        .environment(ContentViewModel(coordinator: AppCordinator()))
}
