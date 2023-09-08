//
//  ArticlePresenter.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import Foundation

class ArticlePresenter: ArticleOutput {

    // MARK: Dependencies
    unowned private var view: ArticleInput
    private var dataManager: AppDataManager
    
    // MARK: Initializer
    init(view: ArticleInput, dataManager: AppDataManager) {
        self.view = view
        self.dataManager = dataManager
    }
    
    // MARK: Public API
    func viewDidLoad() {
        guard let index = view.getArticleIndex() else { return }
        let title = dataManager.getTitleForArticle(atIndex: index)
        let content = dataManager.getContentForArticle(atIndex: index)
        let sourceName = dataManager.getSourceNameForArticle(atIndex: index)
        let date = dataManager.getPublishingDateForArticle(atIndex: index)
        view.setupArticleView(withTitle: title, content: content, sourceName: sourceName, publishingDate: date)
    }

    func viewWillAppear() { 
        self.dataManager.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.view.updateView()
            }
        }
    }
    
    func handleMemoryWarning() {
        dataManager.clearCache()
    }
    
    func getImageData(forArticleIndex index: Int, completion: @escaping (Data?)->()) {
        dataManager.getImageDataforArticle(atIndex: index) { data in
            guard let data = data else { return }
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }
    
    func readInSourceButtonTapped() {
        guard let index = view.getArticleIndex() else { return }
        let urlString = dataManager.getSourceURLforArticle(atIndex: index)
        if let url = URL(string: urlString) {
            view.goToWebArticle(sourceURL: url)
        }
    }
    
}
