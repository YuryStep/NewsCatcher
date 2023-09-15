//
//  FeedPresenter.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 31.08.2023.
//

import Foundation

final class FeedPresenter: FeedOutput {
    // MARK: Dependencies

    private weak var view: FeedInput?
    private var dataManager: AppDataManager

    // MARK: Initializer

    init(view: FeedInput, dataManager: AppDataManager) {
        self.view = view
        self.dataManager = dataManager
    }

    // MARK: FeedOutput

    func viewWillAppear() {
        dataManager.onDataUpdate = { [weak self] in
            self?.view?.reloadFeedTableView()
        }
    }

    func didReceiveMemoryWarning() {
        dataManager.clearCache()
    }

    func searchButtonTapped() {
        guard let searchPhrase = view?.getSearchFieldText() else { return }
        if searchPhrase.isEmpty {
            view?.hideKeyboard()
        } else {
            dataManager.downloadNews(about: searchPhrase, searchCriteria: nil)
            view?.hideKeyboard()
        }
    }

    func settingsButtonTapped() {
        print("settingsButtonTapped")
    }

    func refreshTableViewData() {
        dataManager.downloadNews(about: nil, searchCriteria: nil)
        // TODO: searchCriteria and keyword must be sent in future implementation to save current request properties.
    }

    func getNumberOfRowsInSection() -> Int {
        return dataManager.getNumberOfArticles()
    }

    func getTitle(at indexPath: IndexPath) -> String {
        return dataManager.getTitleForArticle(at: indexPath.row)
    }

    func getDescription(at indexPath: IndexPath) -> String {
        return dataManager.getDescriptionForArticle(at: indexPath.row)
    }

    func getImageData(at indexPath: IndexPath, completion: @escaping (Data?) -> Void) {
        dataManager.getImageDataForArticle(at: indexPath.row) { data in
            guard let data = data else { return }
            completion(data)
        }
    }

    func getSourceName(at indexPath: IndexPath) -> String {
        return dataManager.getSourceNameForArticle(at: indexPath.row)
    }

    func getPublishingDate(at indexPath: IndexPath) -> String {
        return dataManager.getPublishingDateForArticle(at: indexPath.row)
    }

    func didTapOnCell(at indexPath: IndexPath) {
        view?.showArticle(at: indexPath.row, dataManager: dataManager)
    }
}
