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
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(resource: .ncBackground)
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        return navigationController
    }
}
