//
//  String+Extensions.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 05.09.2023.
//

import Foundation

extension String {
    func formattedSearchQuery() -> String {
        let trimmedString = trimmingCharacters(in: .whitespacesAndNewlines)
        let components = trimmedString.components(separatedBy: .whitespaces)
        let joinedString = components.joined(separator: "+")
        return joinedString
    }
}

extension String {
    func dayAndTimeText() -> String {
        guard let date = ISO8601DateFormatter().date(from: self) else { return self }
        return date.dayAndTimeText
    }
}
