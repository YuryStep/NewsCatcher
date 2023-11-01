//
//  SavedNewsPresenter.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 31.10.2023.
//

import UIKit

final class SavedNewsPresenter: SavedNewsOutput {
    private weak var view: SavedNewsInput?
    private var dataManager: AppDataManager

    init(view: SavedNewsInput, dataManager: AppDataManager) {
        self.view = view
        self.dataManager = dataManager
    }

    func getCellDisplayData(for article: Article) -> SavedNewsCell.DisplayData {
        SavedNewsCell.DisplayData(title: article.title,
                                  description: article.description,
                                  publishedAt: article.publishedAt.dayAndTimeText(),
                                  sourceName: article.source.name,
                                  imageData: article.imageData)
    }

    func getSnapshotItems() -> [Article] {
        dataManager.getSavedArticles()?.reversed() ?? []
    }

    func didTapOnCell(with article: Article) {
        view?.showArticle(article)
    }

    func didReceiveMemoryWarning() {
        dataManager.clearCache()
    }
}
