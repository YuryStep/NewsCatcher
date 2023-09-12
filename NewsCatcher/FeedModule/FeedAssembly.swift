//
//  FeedAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

import UIKit

enum FeedAssembly {
    static func makeModule(_ dataManager: AppDataManager) -> UIViewController {
        let feedView = FeedView()
        let feedViewController = FeedViewController(feedView: feedView)
        let feedPresenter = FeedPresenter(view: feedViewController, dataManager: dataManager)
        feedView.delegate = feedViewController
        feedViewController.presenter = feedPresenter
        return feedViewController
    }
}
