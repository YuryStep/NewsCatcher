//
//  UILabel+Extensions.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 08.09.2023.
//

import UIKit

extension UILabel {
    convenience init(textStyle: UIFont.TextStyle, numberOfLines: Int = 0) {
        self.init()
        font = .preferredFont(forTextStyle: textStyle)
        adjustsFontForContentSizeCategory = true
        translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = numberOfLines
    }
}
