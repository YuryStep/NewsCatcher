//
//  DataManager.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

import Foundation

protocol AppDataManager {
    func getNumberOfArticles() -> Int
    func getTitleForArticle(atIndex index: Int) -> String
    func getDescriptionForArticle(atIndex index: Int) -> String
    func getImageDataforArticle(atIndex index: Int, completion: @escaping (Data?) -> Void)
    func clearCache()
}

protocol AppArticle {
    var title: String { get }
    var description: String { get }
    var content: String { get }
    var url: String { get }
    var image: String { get }
    var publishedAt: String { get }
}

class DataManager: AppDataManager {
    private let networkManager: AppNetworkManager
    private let cacheManager: AppCacheManager
    
    private var articles: [AppArticle]?
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
        networkManager.downloadNews(about: nil) { [weak self] articles in
            self?.articles = articles
            self?.onDataUpdate?()
        }
    }
    
    private func getImageData(forArticle article: AppArticle, completion: @escaping (Data?) -> Void) {
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
