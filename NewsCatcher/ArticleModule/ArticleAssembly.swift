//
//  ArticleAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import UIKit

enum ArticleAssembly {
    static func makeModule(index: Int) -> UIViewController {
        let articleView = ArticleView(frame: .zero, index: index)
        let articleViewController = ArticleViewController(articleView: articleView)
        let articlePresenter = ArticlePresenter(view: articleViewController, dataManager: DataManager.shared)
        articleViewController.presenter = articlePresenter
        return articleViewController
    }
}
