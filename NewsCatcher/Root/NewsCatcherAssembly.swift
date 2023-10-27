//
//  NewsCatcherAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 08.09.2023.
//

import UIKit

enum NewsCatcherAssembly {
    // TODO: Remove After SavedArticlesController Assembly Implementation
    private enum Constants {
        static let savedIconName = "Saved"
        static let savedImageIconName = "square.and.arrow.down"
    }

    static func makeModule() -> UIViewController {
        let feedModule = FeedAssembly.makeModule()
        let savedArticlesController = createSavedArticlesController()
        let tabBarController = makeTabBarController(with: [feedModule, savedArticlesController])
        return tabBarController
    }

    // TODO: Remove After SavedArticlesController Assembly Implementation
    private static func createSavedArticlesController() -> UIViewController {
        let savedArticlesController = SavedNewsViewController().wrappedInNavigationController()
        let tabImage = UIImage(systemName: Constants.savedImageIconName)
        savedArticlesController.tabBarItem = UITabBarItem(title: Constants.savedIconName, image: tabImage, tag: 0)
        savedArticlesController.view.backgroundColor = .lightGray
        return savedArticlesController
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
