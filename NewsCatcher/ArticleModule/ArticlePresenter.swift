//
//  ArticlePresenter.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import Foundation

class ArticlePresenter: ArticleOutput {
    
    // MARK: Dependencies
    unowned private var view: ArticleViewController
    private var dataManager: AppDataManager
    
    // MARK: Initializer
    init(view: ArticleViewController, dataManager: AppDataManager) {
        self.view = view
        self.dataManager = dataManager
    }
    
    // MARK: Public API
    func getTitleforArticle(atIndex index: Int) -> String {
         return dataManager.getTitleForArticle(atIndex: index)
    }
    
    func getContentForArticle(atIndex index: Int) -> String {
        return dataManager.getContentForArticle(atIndex: index)
    }
    
    func getImageData(forArticleIndex index: Int, completion: @escaping (Data?)->()) {
        dataManager.getImageDataforArticle(atIndex: index) { data in
            guard let data = data else { return }
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }
    
    func getSourceNameForArticle(atIndex index: Int) -> String {
        return dataManager.getSourceNameForArticle(atIndex: index)
    }
    
    func getPublishingDataForArticle(atIndex index: Int) -> String {
        return dataManager.getPublishingDataForArticle(atIndex: index)
    }
    
    func viewWillAppear() {
        self.dataManager.onDataUpdate = { [weak self] in
            self?.updateView()
        }
    }
    
    func handleMemoryWarning() {
        dataManager.clearCache()
    }
    
    func readInSourceButtonTapped() {
        let index = view.getArticleIndex()
        let urlString = dataManager.getSourceURLforArticle(atIndex: index)
        if let url = URL(string: urlString) {
            view.showWebArticle(sourceURL: url)
        }
    }
    
    // MARK: Private methods
    private func updateView() {
        DispatchQueue.main.async {
            self.view.updateView()
        }
    }
}
