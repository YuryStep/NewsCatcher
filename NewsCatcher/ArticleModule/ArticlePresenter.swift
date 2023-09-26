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
        state = State(article: article)
        self.dataManager = dataManager
    }
}

extension ArticlePresenter: ArticleOutput {
    func viewDidLoad() {
        view?.setupArticleView(withTitle: state.article.title,
                               content: state.article.content,
                               sourceName: state.article.source.name,
                               publishingDate: state.article.publishedAt.dateFormatted())
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
            view?.goToWebArticle(sourceURL: url)
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
