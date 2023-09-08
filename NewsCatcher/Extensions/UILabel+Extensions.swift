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
        self.font = .preferredFont(forTextStyle: textStyle)
        self.adjustsFontForContentSizeCategory = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = numberOfLines
    }
}
