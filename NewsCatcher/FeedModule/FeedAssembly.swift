//
//  FeedAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

import UIKit

class FeedAssembly {
    class func configureModule() -> UIViewController {
        let feedViewControler = FeedViewController()
        let feedView = FeedView()
        let networkManager = NetworkManager()
        let cacheManager = CacheManager()
        let dataManager = DataManager(networkManager: networkManager, cacheManager: cacheManager)
        let feedPresenter = FeedPresenter(view: feedViewControler, dataManager: dataManager)
        
        feedView.delegate = feedViewControler
        feedViewControler.feedView = feedView
        feedViewControler.presenter = feedPresenter
        
        return feedViewControler
    }
}
