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

    func getImageData(completion: @escaping (Data?) -> Void) {
        let imageStringURL = state.article.imageStringURL
        dataManager.getImageData(from: imageStringURL) { [weak self] result in
            guard let self, state.article.imageStringURL == imageStringURL else { return }
            switch result {
            case let .success(imageData):
                completion(imageData)
            case let .failure(error):
                handleError(error)
                completion(nil)
            }
        }
    }

    func readInSourceButtonTapped() {
        if let url = URL(string: state.article.urlString) {
            view?.openWebArticle(sourceURL: url)
        }
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

extension ArticleView.DisplayData {
    init(_ article: Article) {
        self.title = article.title
        self.content = article.content
        self.publishedAt = article.publishedAt.dateFormatted()
        self.sourceName = article.source.name
        self.imageStringURL = article.imageStringURL
    }
}
