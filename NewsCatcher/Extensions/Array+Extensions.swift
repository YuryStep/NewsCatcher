//
//  Array+Extensions.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 05.09.2023.
//

import Foundation

extension Array where Element == String {
    func concatenateWithCommas() -> String {
        return self.joined(separator: ",")
    }
}

extension Array where Element: RawRepresentable, Element.RawValue == String {
    func combineRawValues() -> String {
        let rawValues = self.compactMap { $0.rawValue }
        return rawValues.joined(separator: ",")
    }
}
