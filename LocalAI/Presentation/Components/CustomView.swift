//
//  CustomView.swift
//  LocalAI
//
//  Created by Michele Manniello on 17/05/25.
//

import Foundation
import SwiftUI

struct CustomButton: View {
    @Binding var isSelected: Bool
    var imageName: String
    var titleButton: String
    var action: () -> ()
    
    @State private var isHovered = false

    var body: some View {
        Button(action: {
            isSelected.toggle()
            action()
        }) {
            HStack(spacing: 6) {
                Image(systemName: imageName)
                    .imageScale(.medium)
                Text(titleButton)
                    .font(.system(size: 13, weight: .medium))
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .contentShape(RoundedRectangle(cornerRadius: 6))
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(
                        isSelected ? Color.accentColor.opacity(0.25) :
                        (isHovered ? Color(NSColor.controlAccentColor).opacity(0.12) : Color.clear)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            isHovered = hovering
        }
        .animation(.easeInOut(duration: 0.15), value: isHovered)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
        .padding(.horizontal, 5)
        .padding(.top, 5)
    }
}


#Preview {
    CustomButton( isSelected: .constant(false), imageName: "brain", titleButton:  "Call AI") {
        
    }
    .frame(width: 300, height: 300)
}
