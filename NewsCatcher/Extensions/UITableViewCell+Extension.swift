//
//  UITableViewCell+Extension.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 19.10.2023.
//

import UIKit

extension UITableViewCell {

    static var reuseIdentifier: String {
        String(describing: self)
    }

    var reuseIdentifier: String {
        type(of: self).reuseIdentifier
    }
}
