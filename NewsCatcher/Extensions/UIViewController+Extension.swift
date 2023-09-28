//
//  UIViewController+Extension.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 27.09.2023.
//

import UIKit

extension UIViewController {
    func wrapInNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        return navigationController
    }
}
