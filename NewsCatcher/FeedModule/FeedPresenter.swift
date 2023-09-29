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
    func didReceiveMemoryWarning() {
        dataManager.clearCache()
    }

    func didTapOnSearchButton() {
        guard let searchPhrase = view?.getSearchFieldText() else { return }
        if !searchPhrase.isEmpty {
            displayNews(about: searchPhrase)
        }
        view?.hideKeyboard()
    }

    func didTapOnSettingsButton() {
        view?.showSettings()
        debugPrint("Settings Button Tapped")
    }

    func didTapOnCell(at indexPath: IndexPath) {
        view?.showArticle(state.getArticle(at: indexPath))
    }

    func didPullToRefreshTableViewData() {
        displayNews(about: nil)
        view?.cleanSearchTextField() // TODO: Remove?
    }

    func getNumberOfRowsInSection() -> Int {
        return state.getNewsCount()
    }

    func getFeedDisplayData(at indexPath: IndexPath) -> FeedCell.DisplayData {
        return FeedCell.DisplayData(
            title: state.getArticle(at: indexPath).title,
            description: state.getArticle(at: indexPath).description,
            publishedAt: state.getArticle(at: indexPath).publishedAt.dateFormatted(),
            sourceName: state.getArticle(at: indexPath).source.name,
            imageStringURL: state.getArticle(at: indexPath).imageStringURL
        )
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
            view?.stopFeedDataRefreshing()
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
