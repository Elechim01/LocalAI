//
//  SpeechTextView.swift
//  LocalAI
//
//  Created by Michele Manniello on 04/05/25.
//

import SwiftUI
 enum Layout {
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
    var nameAI: String
    
    @Environment(SpeechToTextViewModel.self) private var viewModel:  SpeechToTextViewModel
    
    var body: some View {
        @Bindable var model = viewModel
        VStack(spacing: Layout.Container.spacing) {
            Text("Parla con l'AI \(nameAI)")
                .font(.title)
            ScrollView {
                TextEditor(text: $model.transcript)
                        .padding(10)
                        .frame(maxWidth: .infinity, minHeight: Layout.ScrollContainer.height)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Layout.ScrollContainer.borderColor, lineWidth: Layout.ScrollContainer.borderWidth)
                        )
            }
            .frame(height: Layout.ScrollContainer.height)
            .border(Layout.ScrollContainer.borderColor, width: Layout.ScrollContainer.borderWidth)
            .padding()
            .onChange(of: viewModel.transcript) {
                self.transcript = $1
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
       // .background(Layout.Container.background)
        .foregroundStyle(Layout.Container.fontColor)
    }
    
   
}

#Preview {
    SpeechToTextView(transcript: .constant(""), nameAI: "assistente")
        .environment( SpeechToTextViewModel(speechToTextService:SpeechToTextServices()))
}
