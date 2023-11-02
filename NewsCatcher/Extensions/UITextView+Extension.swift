//
//  UITextView+Extension.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.11.2023.
//

import UIKit

extension UITextView {
    convenience init(textStyle: UIFont.TextStyle, color: UIColor? = .black) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        isScrollEnabled = false
        isSelectable = true
        adjustsFontForContentSizeCategory = true
        isEditable = false
        font = .preferredFont(forTextStyle: textStyle)
        backgroundColor = .clear
        textColor = color
    }
}
