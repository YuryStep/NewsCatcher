//
//  DataManager.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

import Foundation

class DataManager {
    private let networkManager: NetworkManager
    private let cacheManager: CacheManager
    
    private var articles: [Article]?
    var onDataUpdate: (() -> Void)?

    init(networkManager: NetworkManager, cacheManager: CacheManager) {
        self.networkManager = networkManager
        self.cacheManager = cacheManager
        downloadCurrentNews()
    }
    
    // MARK: Public API
    func getNumberOfArticles() -> Int {
        return articles?.count ?? 0
    }
    
    func getTitleForArticle(atIndex index: Int) -> String {
        return articles?[index].title ?? "no data"
    }
    
    func getDescriptionForArticle(atIndex index: Int) -> String {
        return articles?[index].description ?? "no data"
    }
    
    func getImageDataforArticle(atIndex index: Int, completion: @escaping (Data?) -> Void) {
        guard let article = articles?[index] else { return }
        getImageData(forArticle: article, completion: completion)
    }
    
    func clearCache() {
        cacheManager.clearCache()
    }
    
    // MARK: Private Methods
    private func downloadCurrentNews() {
        networkManager.downloadNews { [weak self] gNews in
            self?.articles = gNews.articles
            self?.onDataUpdate?()
        }
    }
    
    private func getImageData(forArticle article: Article, completion: @escaping (Data?) -> Void) {
        let imageURL = article.image
        if let imageData = cacheManager.getData(forKey: imageURL) {
            completion(imageData)
        } else {
            networkManager.downloadData(from: imageURL) { imageData in
                guard let imageData = imageData else { return }
                self.cacheManager.save(imageData, forKey: imageURL)
                completion(imageData)
            }
        }
    }
    
}
