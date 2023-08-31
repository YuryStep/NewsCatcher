//
//  SceneDelegate.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 30.08.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let feedView = FeedView()
        let feedViewControler = FeedViewController()
        let feedPresenter = FeedPresenter(view: feedViewControler)
        
        feedView.delegate = feedViewControler
        feedViewControler.feedView = feedView
        feedViewControler.presenter = feedPresenter
        feedPresenter.view = feedViewControler
        
        let navigationController = UINavigationController(rootViewController: feedViewControler)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

}

