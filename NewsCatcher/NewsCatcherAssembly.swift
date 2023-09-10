//
//  NewsCatcherAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 08.09.2023.
//

import UIKit

class  {
    class func configureModule() -> UINavigationController {
        let dataManager = DataManagerAssembly.configureModule()
        let firstViewController = FeedAssembly.configureModule(usingDataManager: dataManager)
        let navigationController = UINavigationController(rootViewController: firstViewController)
        return navigationController
    }
}
