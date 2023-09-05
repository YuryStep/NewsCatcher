//
//  String+Extensions.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 05.09.2023.
//

import Foundation

extension String {
    func removeExtraSpaces() -> String {
        // Remove spaces at the beginning and end of a string
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        // Replacing spaces between words with &
        let components = trimmedString.components(separatedBy: .whitespaces)
        let joinedString = components.joined(separator: "&")
        return joinedString
    }
    
}
