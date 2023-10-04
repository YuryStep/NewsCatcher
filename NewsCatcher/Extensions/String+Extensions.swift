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
    func dateFormatted() -> String {
        if let date = ISO8601DateFormatter().date(from: self) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        } else {
            return self
        }
    }
}
