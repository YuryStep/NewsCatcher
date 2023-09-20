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
            guard let self else { return }
            view?.reloadFeedTableView()
        }
    }

    func didReceiveMemoryWarning() {
        dataManager.clearCache()
    }

    func searchButtonTapped() {
        guard let searchPhrase = view?.getSearchFieldText() else { return }
        if !searchPhrase.isEmpty {
            dataManager.downloadNews(about: searchPhrase, searchCriteria: nil) { result in
                switch result {
                case .success(_):
                    return
                case let .failure(error):
                    self.handleError(error)
                }
            }
        }
        view?.hideKeyboard()
    }

    func settingsButtonTapped() {
        print("settingsButtonTapped")
    }

    func refreshTableViewData() {
        // TODO: searchCriteria and keyword must be sent in future implementation to save current request properties.
        dataManager.downloadNews(about: nil, searchCriteria: nil) { result in
            switch result {
            case .success(_):
                return
            case let .failure(error):
                self.handleError(error)
            }
        }
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
        dataManager.getImageDataForArticle(at: indexPath.row) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(imageData):
                completion(imageData)
            case let .failure(error):
                handleError(error)
                completion(nil)
            }
        }
    }

    func getSourceName(at indexPath: IndexPath) -> String {
        return dataManager.getSourceNameForArticle(at: indexPath.row)
    }

    func getPublishingDate(at indexPath: IndexPath) -> String {
        return dataManager.getPublishingDateForArticle(at: indexPath.row)
    }

    func didTapOnCell(at index: Int) {
        view?.showArticle(at: index, dataManager: dataManager)
    }
}

extension FeedPresenter {
    private func handleError(_ error: NetworkError) {
        // TODO: Create error handling cases
        switch error {
        default:
            debugPrint(error.localizedDescription)
        }
    }
}
