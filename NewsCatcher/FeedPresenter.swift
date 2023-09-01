//
//  FeedPresenter.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 31.08.2023.
//

import Foundation

class FeedPresenter {
    
    // MARK: Dependencies
    unowned private var view: FeedViewController
    private let networkManager: NetworkManager
    
    private var articles: [Article]? {
        didSet {
            self.view.feedView.reloadTableViewData()
        }
    }
    
    // MARK: Initializer
    init(view: FeedViewController, networkManager: NetworkManager) {
        self.view = view
        self.networkManager = networkManager
    }
    
    // MARK: Public API
    func getInitialViewSetup() {
        downloadNews()
    }
    
    func getNumberOfRowsInSection() -> Int {
        guard let articles = articles else { return 0 }
        return articles.count
    }
    
    func getTitle(forIndexPath indexPath: IndexPath) -> String {
        guard let articles = articles else { return "no dataç" }
        return articles[indexPath.row].title
    }
    
    func getDescription(forIndexPath indexPath: IndexPath) -> String {
        guard let articles = articles else { return "no data" }
        return articles[indexPath.row].description
    }
    
    func getImageData(forIndexPath indexPath: IndexPath, completion: @escaping (Data?)->()) {
        guard let article = getArticle(forIndexPath: indexPath) else { return }
        getImageData(forArticle: article) { imageData in
            DispatchQueue.main.async {
                completion(imageData)
            }
        }
    }
    
    // User actions response
    func searchButtonTapped() {
        print("searchButtonTapped")
    }
    
    func settingsButtonTapped() {
        print("settingsButtonTapped")
    }
    
    // MARK: Private Methods
    private func downloadNews() {
        networkManager.downloadNews { GNews in
            DispatchQueue.main.async {
                self.articles = GNews.articles
            }
        }
    }
    
    private func getArticle(forIndexPath indexPath: IndexPath) -> Article? {
        return articles?[indexPath.row]
    }
    
    private func getImageData(forArticle article: Article, completion: @escaping (Data)->()) {
        networkManager.downloadData(from: article.image) { data in
            guard let data = data else { return }
            completion(data)
        }
    }
    
}
