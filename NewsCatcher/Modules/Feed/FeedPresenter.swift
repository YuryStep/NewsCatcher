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
        static let errorAlertTextDefault = "Please try again later"
        static let alertTitleNoArticlesFound = "No articles found."
    }

    private struct State {
        private var news = [Article]()

        mutating func setupNews(with news: [Article]) {
            self.news = news
        }

        mutating func setImageDataForArticle(_ data: Data, at indexPath: IndexPath) {
            news[indexPath.row].imageData = data
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
    func didTapOnSearchButton(withKeyword searchPhrase: String) {
        view?.showLoadingIndicator()
        displayNews(about: searchPhrase)
    }

    func didReceiveMemoryWarning() {
        dataManager.clearCache()
    }

    func didTapOnSettingsButton() {
        view?.showSettings()
    }

    func didTapOnCell(at indexPath: IndexPath) {
        let articleImageData = view?.getImageData(for: indexPath)
        var article = state.getArticle(at: indexPath)
        article.imageData = articleImageData
        view?.showArticle(article)
    }

    func didPullToRefreshTableViewData() {
        displayNews(about: nil)
    }

    func getNumberOfRowsInSection() -> Int {
        return state.getNewsCount()
    }

    func getFeedDisplayData(at indexPath: IndexPath) -> FeedCell.DisplayData {
        return FeedCell.DisplayData(state.getArticle(at: indexPath))
    }

    func getImageData(at indexPath: IndexPath, completion: @escaping (Data?) -> Void) {
        let article = state.getArticle(at: indexPath)
        dataManager.getImageData(from: article.imageStringURL) { [weak self] result in
            guard let self, state.getArticle(at: indexPath) == article else { return }
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
                    state.setupNews(with: [])
                    view?.showNoArticlesFoundLabel()
                    view?.reloadFeedTableView()
                } else {
                    state.setupNews(with: news)
                    view?.hideNoArticlesFoundLabel()
                    view?.reloadFeedTableView()
                }
            case let .failure(error):
                handleError(error)
            }
        }
    }

    private func stopViewLoading() {
        view?.stopRefreshControlAnimation()
        view?.hideLoadingIndicator()
    }

    private func handleError(_ error: NetworkError) {
        switch error {
        case .noInternetConnection:
            view?.showAlertWithTitle(Constants.errorAlertTitleNoInternetConnection, text: error.localizedDescription)
        case .forbidden403:
            view?.showAlertWithTitle(Constants.errorAlertTitleDailyLimitReached, text: error.localizedDescription)
        default: return
        }
    }
}

private extension FeedCell.DisplayData {
    init(_ article: Article) {
        title = article.title
        description = article.description
        publishedAt = article.publishedAt.dayAndTimeText()
        sourceName = article.source.name
        imageStringURL = article.imageStringURL
    }
}
