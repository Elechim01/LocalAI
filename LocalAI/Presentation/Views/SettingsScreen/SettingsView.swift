//
//  SettingsView.swift
//  LocalAI
//
//  Created by Michele Manniello on 02/06/25.
//

import SwiftUI

struct SettingsView: View {
    var width: Double
    var height: Double
    @State var attivaPassword: Bool = false
    
//    UserDefaults
    @AppStorage("pythonPath") var pythonPathData = ""
    @AppStorage("textAIColor") var textAiColor: String = ""
    let colorInitial = NSColor(
        hue: 0.6,
        saturation: 0.8,
        brightness: 0.8,
        alpha: 1)
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Python")
                .font(.title2)
            
            Text("Inserisci il path di python in modo da poter collegare LocalAI con l'interprete python")
                .font(.body)
                .padding(.horizontal)
            
            TextField("Path Python", text: $pythonPathData)
                .padding(.horizontal)
                
            
            Text("NB. il path di python deve terminare con un .dylib\nlib/libpython3.10.dylib")
                .font(.subheadline)
                Divider()
            
            Text("Scegli il colore del testo dell AI")
                .font(.title2)
            
            ColorPicker("Seleziona il colore", selection: Binding(get: {
                Color(hex:textAiColor) ?? Color(colorInitial)
            }, set: { color in
                textAiColor = color.toHex(includeAlpha: true) ?? "#FF0000"
            }))
            
           Divider()
            Toggle("attiva la password per l'AI", isOn: $attivaPassword)
            Spacer()
        }
        .frame(width: width,height: height)
    }
}

#Preview {
    SettingsView(width: 400, height: 400)

}
