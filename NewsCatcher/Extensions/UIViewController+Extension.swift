//
//  UIViewController+Extension.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 27.09.2023.
//

import UIKit

extension UIViewController {
    func wrapInNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}
