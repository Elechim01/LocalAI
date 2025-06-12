//
//  ModelButton.swift
//  LocalAI
//
//  Created by Michele Manniello on 07/06/25.
//

import SwiftUI

struct ModelButton: View {
    var title: String
    var imageName: String? = nil
    var customGradient: LinearGradient? = nil
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let imageName = imageName {
                    Image(systemName: imageName)
                        .foregroundColor(.white)
                }

                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(customGradient ?? ModelButtonGradients.defaultGradient)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
        }
        .padding(.horizontal)
        .buttonStyle(PressableButtonStyle())
    }
}


#Preview {
    ModelButton(title: "Premi qui", action: {})
        .frame(width: 300, height: 300)
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)

    }
}

struct ModelButtonGradients {
    static let defaultGradient = LinearGradient(
           gradient: Gradient(colors: [Color.blue, Color.purple]),
           startPoint: .leading,
           endPoint: .trailing
       )

       static let greenGradient = LinearGradient(
           gradient: Gradient(colors: [Color.green.opacity(0.8), Color.mint]),
           startPoint: .leading,
           endPoint: .trailing
       )

       static let redGradient = LinearGradient(
           gradient: Gradient(colors: [Color.red, Color.pink]),
           startPoint: .leading,
           endPoint: .trailing
       )
}
