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
        static let height: CGFloat = 200.0
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

        VStack{
            // Titolo
            
            TitleView(title: "Parla con l'AI \(nameAI)")

            // TextEditor in ScrollView con aspetto moderno
            ScrollView {
                TextEditor(text: $model.transcript)
                    .font(.system(size: 14, design: .monospaced))
                    .padding(12)
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(NSColor.textBackgroundColor))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    .padding(.horizontal)
            }
            .frame(height: Layout.ScrollContainer.height)
            .padding(.bottom)
            .onChange(of: viewModel.transcript) {
                self.transcript = $1
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
//        .background(Color(NSColor.windowBackgroundColor))
        .foregroundStyle(Layout.Container.fontColor)
    }

    
   
}

#Preview {
    SpeechToTextView(transcript: .constant(""), nameAI: "assistente")
        .environment( SpeechToTextViewModel(speechToTextService:SpeechToTextServices()))
}
