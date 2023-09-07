//
//  FeedAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

import UIKit

class FeedAssembly {
    class func configureModule() -> UIViewController {
        let feedView = FeedView()
        let feedViewControler = FeedViewController(feedView: feedView)
        let apiBuilder = APIRequestBuilder()
        let networkManager = NetworkManager(apiRequestBuilder: apiBuilder)
        let cacheManager = CacheManager()
        let dataManager = DataManager<GNews.Article>(networkManager: networkManager, cacheManager: cacheManager)
        let feedPresenter = FeedPresenter(view: feedViewControler, dataManager: dataManager)
        
        feedView.delegate = feedViewControler
        feedViewControler.presenter = feedPresenter
        
        return feedViewControler
    }
}
