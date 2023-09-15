//
//  NewsCatcherAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 08.09.2023.
//

import UIKit

enum NewsCatcherAssembly {
    static func makeModule() -> UINavigationController {
        let firstViewController = FeedAssembly.makeModule(with: DataManager.shared)
        let navigationController = UINavigationController(rootViewController: firstViewController)
        return navigationController
    }
}
