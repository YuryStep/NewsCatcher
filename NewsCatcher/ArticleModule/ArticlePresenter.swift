//
//  ArticlePresenter.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import Foundation

final class ArticlePresenter: ArticleOutput {
    // MARK: Dependencies

    private unowned var view: ArticleInput
    private var dataManager: AppDataManager

    // MARK: Initializer

    init(view: ArticleInput, dataManager: AppDataManager) {
        self.view = view
        self.dataManager = dataManager
    }

    // MARK: ArticleOutput

    func viewDidLoad() {
        guard let index = view.getArticleIndex() else { return }
        let title = dataManager.getTitleForArticle(at: index)
        let content = dataManager.getContentForArticle(at: index)
        let sourceName = dataManager.getSourceNameForArticle(at: index)
        let date = dataManager.getPublishingDateForArticle(at: index)
        view.setupArticleView(withTitle: title, content: content, sourceName: sourceName, publishingDate: date)
    }

    func viewWillAppear() {
        dataManager.onDataUpdate = { [weak self] in
            self?.view.updateView()
        }
    }

    func handleMemoryWarning() {
        dataManager.clearCache()
    }

    func getImageData(atIndex index: Int, completion: @escaping (Data?) -> Void) {
        dataManager.getImageDataForArticle(at: index) { data in
            guard let data = data else { return }
            completion(data)
        }
    }

    func readInSourceButtonTapped() {
        guard let index = view.getArticleIndex() else { return }
        let urlString = dataManager.getSourceURLForArticle(at: index)
        if let url = URL(string: urlString) {
            view.goToWebArticle(sourceURL: url)
        }
    }
}
