//
//  ArticleAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import UIKit

enum ArticleAssembly {
    static func makeModule(_ index: Int, dataManager: AppDataManager) -> UIViewController {
        let articleView = ArticleView(frame: .zero, index: index)
        let articleViewController = ArticleViewController(articleView: articleView)
        let articlePresenter = ArticlePresenter(view: articleViewController, dataManager: dataManager)
        articleViewController.presenter = articlePresenter
        return articleViewController
    }
}
