//
//  ArticleAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import UIKit

enum ArticleAssembly {
    static func makeModule(for article: Article) -> UIViewController {
        let articleView = ArticleView(frame: .zero)
        let articleViewController = ArticleViewController(articleView: articleView)
        let articlePresenter = ArticlePresenter(view: articleViewController, article: article, dataManager: DataManager.shared)
        articleViewController.presenter = articlePresenter
        return articleViewController
    }
}
