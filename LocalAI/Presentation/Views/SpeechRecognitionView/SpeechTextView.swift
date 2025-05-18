//
//  SpeechTextView.swift
//  LocalAI
//
//  Created by Michele Manniello on 04/05/25.
//

import SwiftUI
private enum Layout {
    enum Container {
        static let background: Color = .black
        static let fontColor: Color = .white
        static let spacing: CGFloat = 20.0
    }
    enum ScrollContainer {
        static let height: CGFloat = 100.0
        static let borderWidth: CGFloat = 1.0
        static let borderColor: Color = .white
    }
    enum RecordButton {
        static let startRecordingColor: Color = .green.opacity(0.3)
        static let stopRecordingColor: Color = .red.opacity(0.3)
        static let cornerRadius: CGFloat = 10.0
    }
}


struct SpeechToTextView: View {
    
    @Binding var transcript: String
   
    
    @Environment(SpeechToTextViewModel.self) private var viewModel:  SpeechToTextViewModel
    
    var body: some View {
        
        VStack(spacing: Layout.Container.spacing) {
            Text("Text To Speech")
                .font(.title2)
            ScrollView {
                Text(viewModel.transcript)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: Layout.ScrollContainer.height)
            .border(Layout.ScrollContainer.borderColor, width: Layout.ScrollContainer.borderWidth)
            .padding()
            .onChange(of: viewModel.transcript) {
                self.transcript = $1
            }
            
            Button(action: toggleRecord) {
                HStack {
                    Image(systemName: viewModel.isRecording ? "stop.fill" : "mic.fill")
                    Text(viewModel.isRecording ? "Stop" : "Start")
                    
                }
            }
            .padding()
            .buttonStyle(PlainButtonStyle())
            .background(
                viewModel.isRecording ? Layout.RecordButton.stopRecordingColor : Layout.RecordButton.startRecordingColor
            )
            .cornerRadius(Layout.RecordButton.cornerRadius)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
       // .background(Layout.Container.background)
        .foregroundStyle(Layout.Container.fontColor)
    }
    
    private func toggleRecord() {
        if viewModel.isRecording {
            viewModel.stopRecording()
        } else {
            viewModel.startRecording()
        }
    }
}

#Preview {
    SpeechToTextView(transcript: .constant(""))
        .environment( SpeechToTextViewModel(speechToTextService:SpeechToTextServices()))
}
