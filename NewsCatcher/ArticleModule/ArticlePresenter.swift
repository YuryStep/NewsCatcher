//
//  ArticlePresenter.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import Foundation

final class ArticlePresenter: ArticleOutput {
    private weak var view: ArticleInput?
    private var dataManager: AppDataManager

    init(view: ArticleInput, dataManager: AppDataManager) {
        self.view = view
        self.dataManager = dataManager
    }

    func viewDidLoad() {
        guard let index = view?.getArticleIndex() else { return }
        let title = dataManager.getTitleForArticle(at: index)
        let content = dataManager.getContentForArticle(at: index)
        let sourceName = dataManager.getSourceNameForArticle(at: index)
        let date = dataManager.getPublishingDateForArticle(at: index)
        view?.setupArticleView(withTitle: title, content: content, sourceName: sourceName, publishingDate: date)
    }

    func viewWillAppear() {
        dataManager.onDataUpdate = { [weak self] in
            guard let self else { return }
            view?.updateView()
        }
    }

    func handleMemoryWarning() {
        dataManager.clearCache()
    }

    func getImageData(atIndex index: Int, completion: @escaping (Data?) -> Void) {
        dataManager.getImageDataForArticle(at: index) { result in
            switch result {
            case let .success(imageData): completion(imageData)
            case let .failure(error):
                self.handleError(error)
                completion(nil)
            }
        }
    }

    func readInSourceButtonTapped() {
        guard let index = view?.getArticleIndex() else { return }
        let urlString = dataManager.getSourceURLForArticle(at: index)
        if let url = URL(string: urlString) {
            view?.goToWebArticle(sourceURL: url)
        }
    }
}

extension ArticlePresenter {
    private func handleError(_ error: NetworkError) {
        // TODO: Create error handling cases
        switch error {
        default:
            debugPrint(error.localizedDescription)
        }
    }
}
