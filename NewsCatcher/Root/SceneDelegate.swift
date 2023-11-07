//
//  SceneDelegate.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 30.08.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = NewsCatcherAssembly.makeModule()
        window?.makeKeyAndVisible()
    }
}
