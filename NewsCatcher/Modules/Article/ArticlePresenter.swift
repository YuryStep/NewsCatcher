//
//  ArticlePresenter.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import Foundation

final class ArticlePresenter {
    private struct State {
        var article: Article
    }

    private weak var view: ArticleInput?
    private var dataManager: AppDataManager
    private var state: State

    private var storageContainsCurrentArticle: Bool {
        let storedArticles = dataManager.getSavedArticles() ?? []
        return storedArticles.contains(state.article)
    }

    init(view: ArticleInput, article: Article, dataManager: AppDataManager) {
        self.view = view
        state = State(article: article)
        self.dataManager = dataManager
    }
}

extension ArticlePresenter: ArticleOutput {
    func viewDidLoad() {
        updateArticleView()
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
        if state.article.isSavedInLocalStorage {
            dataManager.removeArticle(state.article)
        } else {
            dataManager.saveArticle(state.article)
        }
        updateArticleView()
    }

    private func updateArticleView() {
        state.article.isSavedInLocalStorage = storageContainsCurrentArticle
        let displayData = ArticleView.DisplayData(state.article)
        view?.configureArticleView(with: displayData)
    }
}

private extension ArticleView.DisplayData {
    init(_ article: Article) {
        title = article.title
        content = article.content
        publishedAt = article.publishedAt.dayAndTimeText()
        sourceName = article.source.name
        imageData = article.imageData
        isSaved = article.isSavedInLocalStorage
    }
}
