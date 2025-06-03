//
//  AIInternalModel.swift
//  LocalAI
//
//  Created by Michele Manniello on 02/06/25.
//

import Foundation
struct AIInternalModel: Equatable,Hashable {
    let Uid = UUID().uuidString
    var name: String?
    var id: String?
    var size: String?
    var modified: String?
    
    
    var nameModel: String? {
        return extractModelName(from: name)
    }
    
    init(row: String,header: String?) {
        guard let header = header, let offsets = columnOffsets(header: header)  else { return }
        
          self.name = row[offsets.name..<offsets.id].trimmingCharacters(in: .whitespaces)
           self.id = row[offsets.id..<offsets.size].trimmingCharacters(in: .whitespaces)
           self.size = row[offsets.size..<offsets.modified].trimmingCharacters(in: .whitespaces)
           self.modified = row[offsets.modified..<row.count].trimmingCharacters(in: .whitespaces)
    
    }
    
    func columnOffsets(header: String) -> (name: Int, id: Int, size: Int, modified: Int)? {
        guard let n = header.firstIndex(of: "N"),
              let i = header.firstIndex(of: "I"),
              let s = header.firstIndex(of: "S"),
              let m = header.firstIndex(of: "O") else {
            return nil
        }
        var modifier = header.distance(from: header.startIndex, to: m)
        modifier = modifier - 1
        return (
            name: header.distance(from: header.startIndex, to: n),
            id: header.distance(from: header.startIndex, to: i),
            size: header.distance(from: header.startIndex, to: s),
            modified: modifier
        )
    }
    
    
    
    func extractModelName(from fullName: String?) -> String? {
        guard let fullName = fullName else { return nil }
        // Prende la parte dopo l'ultimo "/"
        let afterSlash = fullName.components(separatedBy: "/").last ?? fullName
        // Prende la parte prima di ":"
        let nameOnly = afterSlash.components(separatedBy: ":").first ?? afterSlash
        return nameOnly
    }

    static func == (lhs: AIInternalModel, rhs: AIInternalModel) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
    
}
