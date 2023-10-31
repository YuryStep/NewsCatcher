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

    func getSnapshotItems() -> [Article] {
        dataManager.getSavedArticles() ?? []
    }

    func didTapOnCell(with article: Article) {
        view?.showArticle(article)
    }

    func didReceiveMemoryWarning() {
        dataManager.clearCache()
    }
}
