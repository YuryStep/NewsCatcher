//
//  FeedPresenter.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 31.08.2023.
//

import Foundation

final class FeedPresenter {
    private enum Constants {
        static let errorAlertTitleNoInternetConnection = "No Internet Connection"
        static let errorAlertTitleDailyLimitReached = "Daily Request Limit Reached"
        static let alertTitleNoArticlesFound = "No articles found"
        static let alertTextNoArticlesFound = "No news articles found. Please try to change your request."
    }

    private struct State {
        private var news = [Article]()

        mutating func setupNews(with news: [Article]) {
            self.news = news
        }

        func getArticle(atIndex index: Int) -> Article? {
            // TODO: Does it really needed to have this check?
            guard index >= 0, index < news.count else { return nil }
            return news[index]
        }

        func getNewsCount() -> Int {
            return news.count
        }

        func getTitle(atIndex index: Int) -> String {
            guard index >= 0, index < news.count else { return "" }
            return news[index].title
        }

        func getDescription(atIndex index: Int) -> String {
            guard index >= 0, index < news.count else { return "" }
            return news[index].description
        }

        func getSourceName(atIndex index: Int) -> String {
            guard index >= 0, index < news.count else { return "" }
            return news[index].source.name
        }

        func getPublishingDate(atIndex index: Int) -> String {
            guard index >= 0, index < news.count else { return "" }
            return news[index].publishedAt.dateFormatted()
        }

        func getImageStringURLForArticle(atIndex index: Int) -> String {
            return news[index].imageStringURL
        }

    }

    private weak var view: FeedInput?
    private var dataManager: AppDataManager
    private var state: State

    init(view: FeedInput, dataManager: AppDataManager) {
        self.view = view
        self.dataManager = dataManager
        self.state = State()
        loadCurrentNews()
    }
}

extension FeedPresenter: FeedOutput {
    func didReceiveMemoryWarning() {
        dataManager.clearCache()
    }

    func didTapOnSearchButton() {
        guard let searchPhrase = view?.getSearchFieldText() else { return }
        if !searchPhrase.isEmpty {
            displayNews(about: searchPhrase, searchCriteria: nil)
        }
        view?.hideKeyboard()
    }

    func didTapOnSettingsButton() {
        debugPrint("Settings Button Tapped")
    }

    func didTapOnCell(at indexPath: IndexPath) {
        guard let targetArticle = state.getArticle(atIndex: indexPath.row) else { return }
        view?.showArticle(targetArticle)
    }

    func refreshTableViewData() {
        displayNews(about: nil, searchCriteria: nil)
        view?.cleanSearchTextField()
    }

    func getNumberOfRowsInSection() -> Int {
        return state.getNewsCount()
    }

    func getTitle(at indexPath: IndexPath) -> String {
        return state.getTitle(atIndex: indexPath.row)
    }

    func getDescription(at indexPath: IndexPath) -> String {
        return state.getDescription(atIndex: indexPath.row)
    }

    func getImageData(at indexPath: IndexPath, completion: @escaping (Data?) -> Void) {
        let imageStringURL = state.getImageStringURLForArticle(atIndex: indexPath.row)
        dataManager.getImageData(from: imageStringURL) { [weak self] result in
            guard let self, state.getImageStringURLForArticle(atIndex: indexPath.row) == imageStringURL else { return }
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
        return state.getSourceName(atIndex: indexPath.row)
    }

    func getPublishingDate(at indexPath: IndexPath) -> String {
        return state.getPublishingDate(atIndex: indexPath.row)
    }

    private func loadCurrentNews() {
        dataManager.getCurrentNews { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(fetchedNews):
                state.setupNews(with: fetchedNews)
            case let .failure(error):
                handleError(error)
            }
        }
    }

    private func displayNews(about searchPhrase: String?, searchCriteria: SearchCriteria?) {
        dataManager.getNews(about: searchPhrase, searchCriteria: searchCriteria) { [weak self] result in
            guard let self else { return }
            view?.stopFeedDataRefreshing() // TODO: It doesn't work
            switch result {
            case let .success(news):
                if news.isEmpty {
                    // TODO: Optional: Change it from alert to view with text in the center instead of FeedTable
                    view?.showAlertWithTitle(Constants.alertTitleNoArticlesFound, text: Constants.alertTextNoArticlesFound)
                } else {
                    state.setupNews(with: news)
                    view?.reloadFeedTableView()
                }
            case let .failure(error):
                handleError(error)
            }
        }
    }

    private func handleError(_ error: NetworkError) {
        switch error {
        case .noInternetConnection:
            view?.showAlertWithTitle(Constants.errorAlertTitleNoInternetConnection, text: error.localizedDescription)
        case .forbidden403:
            view?.showAlertWithTitle(Constants.errorAlertTitleDailyLimitReached, text: error.localizedDescription)
        default:
            debugPrint(error.localizedDescription)
        }
    }
}
