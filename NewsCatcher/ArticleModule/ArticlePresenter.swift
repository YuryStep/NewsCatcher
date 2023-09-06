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
    func getTitle(forArticleIndex index: Int) -> String {
         return dataManager.getTitleForArticle(atIndex: index)
    }
    
    func getContent(forArticleIndex index: Int) -> String {
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
    
    func viewWillAppear() {
        self.dataManager.onDataUpdate = { [weak self] in
            self?.updateView()
        }
    }
    
    func handleMemoryWarning() {
        dataManager.clearCache()
    }
    
    // MARK: Private methods
    private func updateView() {
        DispatchQueue.main.async {
            self.view.updateView()
        }
    }
}
