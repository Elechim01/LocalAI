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
        VStack(alignment: .leading, spacing: 20) {
            
            GroupBox(label: Label("Configurazione Python", systemImage: "terminal")) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Inserisci il percorso dell'interprete Python per collegarlo con LocalAI.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("Path Python (es. /usr/local/lib/libpython3.10.dylib)", text: $pythonPathData)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.system(size: 13, design: .monospaced))
                    
                    Text("⚠️ Deve terminare con `.dylib`, ad esempio `lib/libpython3.10.dylib`.")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .padding(8)
            }
            
            GroupBox(label: Label("Aspetto AI", systemImage: "paintpalette")) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Scegli il colore del testo visualizzato per l'AI.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    ColorPicker("Colore del testo", selection: Binding(get: {
                        Color(hex: textAiColor) ?? Color(colorInitial)
                    }, set: { color in
                        textAiColor = color.toHex(includeAlpha: true) ?? "#FF0000"
                    }))
                    .labelsHidden()
                }
                .padding(8)
            }
            
            GroupBox(label: Label("Sicurezza", systemImage: "lock.shield")) {
                Toggle("Attiva la password per l'AI", isOn: $attivaPassword)
                    .toggleStyle(SwitchToggleStyle())
                    .padding(.top, 5)
            }
            
            Spacer()
        }
        .padding(20)
        .frame(width: width, height: height)
    }

}

#Preview {
    SettingsView(width: 400, height: 400)

}
