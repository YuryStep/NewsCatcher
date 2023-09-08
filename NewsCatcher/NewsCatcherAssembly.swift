//
//  NewsCatcherAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 08.09.2023.
//

import UIKit

class NewsCatcherAssembly {
    class func configureModule() -> UIViewController {
        let dataManager = DataManagerAssembly.configureModule()
        let rootViewController = FeedAssembly.configureModule(usingDataManager: dataManager)
        return rootViewController
    }
}
