//
//  TitleView.swift
//  LocalAI
//
//  Created by Michele Manniello on 07/06/25.
//

import SwiftUI

struct TitleView: View {
    
    var title: String
    var body: some View {
        Text(title)
            .font(.system(size: 24, weight: .semibold, design: .rounded))
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal)
    }
}

#Preview {
    TitleView(title:"Parla con l'AI ")
}
