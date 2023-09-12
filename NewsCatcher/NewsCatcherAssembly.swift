//
//  NewsCatcherAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 08.09.2023.
//

import UIKit

enum NewsCatcherAssembly {
    static func makeModule() -> UINavigationController {
        let dataManager = DataManagerAssembly.makeModule()
        let firstViewController = FeedAssembly.makeModule(dataManager)
        let navigationController = UINavigationController(rootViewController: firstViewController)
        return navigationController
    }
}
