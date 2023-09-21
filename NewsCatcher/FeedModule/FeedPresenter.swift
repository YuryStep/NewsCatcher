//
//  FeedPresenter.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 31.08.2023.
//

import Foundation

final class FeedPresenter {
    struct State {
        var news: [Article]
    }

    private weak var view: FeedInput?
    private var dataManager: AppDataManager
    private var state: State

    init(view: FeedInput, dataManager: AppDataManager) {
        self.view = view
        self.dataManager = dataManager
        state = State(news: [Article]())
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
        view?.showArticle(state.news[indexPath.row])
    }

    func refreshTableViewData() {
        displayNews(about: nil, searchCriteria: nil)
        view?.cleanSearchTextField()
    }

    func getNumberOfRowsInSection() -> Int {
        return state.news.count
    }

    func getTitle(at indexPath: IndexPath) -> String {
        return state.news[indexPath.row].title
    }

    func getDescription(at indexPath: IndexPath) -> String {
        return state.news[indexPath.row].description
    }

    func getImageData(at indexPath: IndexPath, completion: @escaping (Data?) -> Void) {
        let imageStringURL = state.news[indexPath.row].imageStringURL
        dataManager.getImageData(from: imageStringURL) { [weak self] result in
            guard let self, state.news[indexPath.row].imageStringURL == imageStringURL else { return }
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
        return state.news[indexPath.row].source.name
    }

    func getPublishingDate(at indexPath: IndexPath) -> String {
        return state.news[indexPath.row].publishedAt.dateFormatted()
    }

    private func loadCurrentNews() {
        dataManager.getCurrentNews { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(fetchedNews):
                state.news = fetchedNews
            case let .failure(error):
                handleError(error)
            }
        }
    }

    private func displayNews(about searchPhrase: String?, searchCriteria: SearchCriteria?) {
        dataManager.getNews(about: searchPhrase, searchCriteria: searchCriteria) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(news):
                if news.isEmpty {
                    // TODO: Make Alert or changeView
                    debugPrint("There is no any news articles found. Try to change your request.")
                } else {
                    self.state.news = news
                    view?.reloadFeedTableView()
                }
            case let .failure(error):
                handleError(error)
            }
        }
    }

    private func handleError(_ error: NetworkError) {
        // TODO: Create error handling cases
        switch error {
        default:
            debugPrint(error.localizedDescription)
        }
    }
}
