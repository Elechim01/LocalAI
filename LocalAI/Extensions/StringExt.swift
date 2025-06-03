//
//  StringExt.swift
//  LocalAI
//
//  Created by Michele Manniello on 02/06/25.
//

import Foundation
extension String {
    subscript (bounds: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound, limitedBy: endIndex) ?? endIndex
        let end = index(startIndex, offsetBy: bounds.upperBound, limitedBy: endIndex) ?? endIndex
        return String(self[start..<end])
    }
}
