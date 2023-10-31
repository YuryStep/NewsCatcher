//
//  SavedNewsAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 31.10.2023.
//

import UIKit

enum SavedNewsAssembly {
    private enum Constants {
        static let tabIconName = "Saved"
        static let tabImageName = "square.and.arrow.down"
    }

    static func makeModule() -> UIViewController {
        let savedNewsController = SavedNewsViewController()
        let savedNewsPresenter = SavedNewsPresenter(view: savedNewsController, dataManager: DataManager.shared)
        savedNewsController.presenter = savedNewsPresenter

        let tabImage = UIImage(systemName: Constants.tabImageName)
        savedNewsController.tabBarItem = UITabBarItem(title: Constants.tabIconName, image: tabImage, tag: 0)

        return savedNewsController.wrappedInNavigationController()
    }
}
