//
//  UIView+Extensions.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 04.10.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
