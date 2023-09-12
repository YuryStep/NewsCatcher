//
//  Array+Extensions.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 05.09.2023.
//

extension Array where Element == String {
    func concatenateWithCommas() -> String {
        return joined(separator: ",")
    }
}

extension Array where Element: RawRepresentable, Element.RawValue == String {
    func combineRawValues() -> String {
        let rawValues = compactMap { $0.rawValue }
        return rawValues.joined(separator: ",")
    }
}
