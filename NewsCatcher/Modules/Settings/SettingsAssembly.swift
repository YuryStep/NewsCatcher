//
//  SettingsAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 28.09.2023.
//

import UIKit

enum SettingsAssembly {
    static func makeModule() -> UIViewController {
        let settingsPresenter = SettingsPresenter(dataManager: DataManager.shared)
        let settingsViewController = SettingsViewController(presenter: settingsPresenter)
        settingsPresenter.view = settingsViewController
        return settingsViewController.wrapInNavigationController()
    }
}
