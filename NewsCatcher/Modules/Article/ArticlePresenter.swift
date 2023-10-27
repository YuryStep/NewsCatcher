//
//  ArticlePresenter.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import Foundation

final class ArticlePresenter {
    private struct State {
        private(set) var article: Article

        init(_ article: Article) {
            self.article = article
        }
    }

    private weak var view: ArticleInput?
    private var dataManager: AppDataManager
    private var state: State

    init(view: ArticleInput, article: Article, dataManager: AppDataManager) {
        self.view = view
        state = State(article)
        self.dataManager = dataManager
    }
}

extension ArticlePresenter: ArticleOutput {
    func viewDidLoad() {
        let displayData = getDisplayDataForCurrentState()
        view?.setupArticleView(with: displayData)
    }

    func didReceiveMemoryWarning() {
        dataManager.clearCache()
    }

    func readInSourceButtonTapped() {
        if let url = URL(string: state.article.urlString) {
            view?.openWebArticle(sourceURL: url)
        }
    }

    func readLaterButtonTapped() {
        // TODO: Make switch check weather article is saved or not. And then save it or delete
        dataManager.saveArticle(state.article)
    }

    private func getDisplayDataForCurrentState() -> ArticleView.DisplayData {
        return ArticleView.DisplayData(state.article)
    }

    private func handleError(_ error: NetworkError) {
        // TODO: Create error handling cases
        switch error {
        default:
            debugPrint(error.localizedDescription)
        }
    }
}

fileprivate extension ArticleView.DisplayData {
    init(_ article: Article) {
        title = article.title
        content = article.content
        publishedAt = article.publishedAt.dayAndTimeText()
        sourceName = article.source.name
        imageData = article.imageData
    }
}
