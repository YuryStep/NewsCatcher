//
//  FeedAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

import UIKit

class FeedAssembly {
    class func configureModule(usingDataManager dataManager: AppDataManager) -> UIViewController {
        let feedView = FeedView()
        let feedViewControler = FeedViewController(feedView: feedView)
        let feedPresenter = FeedPresenter(view: feedViewControler, dataManager: dataManager)
        
        feedView.delegate = feedViewControler
        feedViewControler.presenter = feedPresenter
        
        return feedViewControler
    }
}
