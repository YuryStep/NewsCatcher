//
//  ArticleAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import UIKit

class ArticleAssembly {
    class func configureModule(withIndex index: Int, dataManager: AppDataManager) -> UIViewController {
        let articleView = ArticleView(frame: .zero, index: index)
        let articleViewControler = ArticleViewController(articleView: articleView)
        let articlePresenter = ArticlePresenter(view: articleViewControler, dataManager: dataManager)

        articleViewControler.presenter = articlePresenter
        return articleViewControler
    }
}
