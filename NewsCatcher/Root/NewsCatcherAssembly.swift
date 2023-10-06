//
//  NewsCatcherAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 08.09.2023.
//

import UIKit

enum NewsCatcherAssembly {
    static func makeModule() -> UINavigationController {
        let firstViewController = FeedAssembly.makeModule()
        let navigationController = UINavigationController(rootViewController: firstViewController)
        navigationController.navigationBar.backgroundColor = UIColor(resource: .ncBackground)

        return navigationController
    }
}
