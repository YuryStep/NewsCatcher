//
//  UILabel+Extensions.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 08.09.2023.
//

import UIKit

extension UILabel {
    convenience init(textStyle: UIFont.TextStyle, color: UIColor? = .black, numberOfLines: Int = 0) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        adjustsFontForContentSizeCategory = true
        self.numberOfLines = numberOfLines
        font = .preferredFont(forTextStyle: textStyle)
        textColor = color
    }
}
