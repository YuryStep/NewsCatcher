//
//  String+Extensions.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 05.09.2023.
//

extension String {
    func removeExtraSpaces() -> String {
        let trimmedString = trimmingCharacters(in: .whitespacesAndNewlines)
        let components = trimmedString.components(separatedBy: .whitespaces)
        let joinedString = components.joined(separator: "&")
        return joinedString
    }
}
