//
//  FeedAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

import UIKit

enum FeedAssembly {
    private enum Constants {
        static let tabIconName = "Feed"
        static let tabImageName = "newspaper"
    }

    static func makeModule() -> UIViewController {
        let feedView = FeedView()
        let feedViewController = FeedViewController(feedView: feedView)
        let feedPresenter = FeedPresenter(view: feedViewController, dataManager: DataManager.shared)
        feedView.delegate = feedViewController
        feedViewController.presenter = feedPresenter

        let tabImage = UIImage(systemName: Constants.tabImageName)
        feedViewController.tabBarItem = UITabBarItem(title: Constants.tabIconName, image: tabImage, tag: 0)

        return feedViewController.wrappedInNavigationController()
    }
}
