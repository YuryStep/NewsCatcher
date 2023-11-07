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

    init(view: ArticleInput, article: Article, dataManager: AppDataManager) {
        self.view = view
        self.dataManager = dataManager
        state = State(article: article)
    }
}

extension ArticlePresenter: ArticleOutput {
    func viewWillAppear() {
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
        if isArticleSaved(state.article) {
            dataManager.removeArticle(state.article)
        } else {
            dataManager.saveArticle(state.article)
        }
        updateArticleView()
    }

    private func updateArticleView() {
        let displayData = getDisplayDataFor(state.article)
        view?.configureArticleView(with: displayData)
    }

    private func isArticleSaved(_ article: Article) -> Bool {
        let savedArticles = dataManager.getSavedArticles() ?? []
        return savedArticles.contains(article)
    }

    private func getDisplayDataFor(_ article: Article) -> ArticleView.DisplayData {
        ArticleView.DisplayData(title: article.title,
                                content: article.content,
                                publishedAt: article.publishedAt.dayAndTimeText(),
                                sourceName: article.source.name,
                                imageData: article.imageData,
                                isSaved: isArticleSaved(article))
    }
}
