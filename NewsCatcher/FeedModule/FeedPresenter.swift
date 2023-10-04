//
//  FeedPresenter.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 31.08.2023.
//

import Foundation

final class FeedPresenter {
    private enum Constants {
        static let errorAlertTitleNoInternetConnection = "No Internet Connection."
        static let errorAlertTitleDailyLimitReached = "Daily Request Limit Reached."
        static let alertTitleNoArticlesFound = "No articles found."
        static let alertTextNoArticlesFound = "No news articles found. Please try to change your request."
    }

    private struct State {
        private var news = [Article]()

        mutating func setupNews(with news: [Article]) {
            self.news = news
        }

        func getArticle(at indexPath: IndexPath) -> Article {
            return news[indexPath.row]
        }

        func getNewsCount() -> Int {
            return news.count
        }
    }

    private weak var view: FeedInput?
    private var dataManager: AppDataManager
    private var state: State

    init(view: FeedInput, dataManager: AppDataManager) {
        self.view = view
        self.dataManager = dataManager
        state = State()
        loadCurrentNews()
    }
}

extension FeedPresenter: FeedOutput {
    func textFieldDidBeginEditing() {
        view?.showCancelButton()
        view?.hideNavigationBar()
    }

    func textFieldShouldReturn() {
        guard let searchPhrase = view?.getSearchFieldText() else { return }
        if !searchPhrase.isEmpty {
            view?.showLoadingIndicator()
            displayNews(about: searchPhrase)
        }
        switchLayoutBackToInitialState()
    }

    func didReceiveMemoryWarning() {
        dataManager.clearCache()
    }

    func didTapOnCancelButton() {
        switchLayoutBackToInitialState()
    }

    func didTapOnSettingsButton() {
        view?.showSettings()
        debugPrint("Settings Button Tapped")
    }

    func didTapOnCell(at indexPath: IndexPath) {
        switchLayoutBackToInitialState()
        view?.showArticle(state.getArticle(at: indexPath))
    }

    func didPullToRefreshTableViewData() {
        displayNews(about: nil)
        view?.cleanSearchTextField() // TODO: Remove after refreshing logic change
    }

    func getNumberOfRowsInSection() -> Int {
        return state.getNewsCount()
    }

    func getFeedDisplayData(at indexPath: IndexPath) -> FeedCell.DisplayData {
        return FeedCell.DisplayData(state.getArticle(at: indexPath))
    }

    func getImageData(at indexPath: IndexPath, completion: @escaping (Data?) -> Void) {
        let imageStringURL = state.getArticle(at: indexPath).imageStringURL
        dataManager.getImageData(from: imageStringURL) { [weak self] result in
            guard let self, state.getArticle(at: indexPath).imageStringURL == imageStringURL else { return }
            switch result {
            case let .success(imageData):
                completion(imageData)
            case let .failure(error):
                handleError(error)
                completion(nil)
            }
        }
    }

    private func loadCurrentNews() {
        dataManager.getCurrentNews { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(fetchedNews):
                state.setupNews(with: fetchedNews)
                view?.reloadFeedTableView()
            case let .failure(error):
                handleError(error)
            }
        }
    }

    private func displayNews(about searchPhrase: String?) {
        dataManager.getNews(about: searchPhrase) { [weak self] result in
            guard let self else { return }
            stopViewLoading()
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

    private func stopViewLoading() {
        view?.stopFeedDataRefreshing()
        view?.hideLoadingIndicator()
    }

    private func switchLayoutBackToInitialState() {
        view?.deactivateSearchField()
        view?.hideCancelButton()
        view?.showNavigationBar()
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

extension FeedCell.DisplayData {
    init(_ article: Article) {
        self.title = article.title
        self.description = article.description
        self.publishedAt = article.publishedAt.dateFormatted()
        self.sourceName = article.source.name
        self.imageStringURL = article.imageStringURL
    }
}
