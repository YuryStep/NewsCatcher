//
//  SettingsAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 28.09.2023.
//

import UIKit

enum SettingsAssembly {
    static func makeModule() -> UIViewController {
        let settingsPresenter = SettingsPresenter()
        let settingsViewController = SettingsViewController(presenter: settingsPresenter).wrapInNavigationController()
        return settingsViewController
    }
}
