//
//  UIViewController+Extension.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 27.09.2023.
//

import UIKit

extension UIViewController {
    func wrappedInNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}
