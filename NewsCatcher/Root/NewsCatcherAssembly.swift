//
//  NewsCatcherAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 08.09.2023.
//

import UIKit

enum NewsCatcherAssembly {
    static func makeModule() -> UIViewController {
        let feedModule = FeedAssembly.makeModule()
        let savedArticlesController = SavedNewsAssembly.makeModule()
        let tabBarController = makeTabBarController(with: [feedModule, savedArticlesController])
        return tabBarController
    }

    private static func makeTabBarController(with viewControllers: [UIViewController]) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = viewControllers
        turnOffTabBarTransparency()
        return tabBarController
    }

    private static func turnOffTabBarTransparency() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
