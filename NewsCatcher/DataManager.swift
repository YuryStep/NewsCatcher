//
//  DataManager.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

import Foundation

protocol AppDataManager {
    func downloadNews(about: String?, searchCriteria: ArticleSearchCriteria?)
    func getNumberOfArticles() -> Int
    func getTitleForArticle(atIndex index: Int) -> String
    func getDescriptionForArticle(atIndex index: Int) -> String
    func getContentForArticle(atIndex index: Int) -> String
    func getImageDataforArticle(atIndex index: Int, completion: @escaping (Data?) -> Void)
    func clearCache()
    var onDataUpdate: (() -> ())? { get set }
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
    var onDataUpdate: (() -> ())?

    init(networkManager: AppNetworkManager, cacheManager: AppCacheManager) {
        self.networkManager = networkManager
        self.cacheManager = cacheManager
        downloadNews(about: nil, searchCriteria: nil)
    }
    
    // MARK: Public API
    func downloadNews(about keyward: String?, searchCriteria: ArticleSearchCriteria?) {
        networkManager.downloadNews(about: keyward, usingSearchCriteria: searchCriteria) { [weak self] articles in
            self?.articles = articles
            self?.onDataUpdate?()
        }
    }
    
    func getNumberOfArticles() -> Int {
        return articles?.count ?? 0
    }
    
    func getTitleForArticle(atIndex index: Int) -> String {
        return articles?[index].title ?? "no data"
    }
    
    func getDescriptionForArticle(atIndex index: Int) -> String {
        return articles?[index].description ?? "no data"
    }
    
    func getContentForArticle(atIndex index: Int) -> String {
        return articles?[index].content ?? "no data"
    }
    
    func getImageDataforArticle(atIndex index: Int, completion: @escaping (Data?) -> Void) {
        guard let article = articles?[index] else { return }
        getImageData(forArticle: article, completion: completion)
    }
    
    func clearCache() {
        cacheManager.clearCache()
    }
    
    // MARK: Private Methods
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
