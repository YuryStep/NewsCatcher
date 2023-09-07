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
    func getSourceURLforArticle(atIndex index: Int) -> String
    func getSourceNameForArticle(atIndex: Int) -> String
    func getPublishingDataForArticle(atIndex: Int) -> String
    func clearCache()
    var onDataUpdate: (() -> ())? { get set }
}

protocol AppArticle: Codable {
    var title: String { get }
    var description: String { get }
    var content: String { get }
    var url: String { get }
    var image: String { get }
    var publishedAt: String { get }
    var sourceName: String { get }
}

class DataManager<Article: AppArticle>: AppDataManager {
    
    private let networkManager: AppNetworkManager
    private let cacheManager: AppCacheManager
    
    private var articles: [Article]?
    var onDataUpdate: (() -> ())?

    init(networkManager: AppNetworkManager, cacheManager: AppCacheManager) {
        self.networkManager = networkManager
        self.cacheManager = cacheManager
        loadArticles()
        if articles == nil {
            downloadNews(about: nil, searchCriteria: nil)
        }
    }
    
    // MARK: Public API
    func downloadNews(about keyward: String?, searchCriteria: ArticleSearchCriteria?) {
        networkManager.downloadNews(about: keyward, usingSearchCriteria: searchCriteria) { [weak self] appArticles in
            let articles = appArticles.compactMap { $0 as? Article }
            self?.articles = articles
            self?.saveArticles()
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
    
    func getSourceURLforArticle(atIndex index: Int) -> String {
        return articles?[index].url ?? "https://www.apple.com/" // FIX apple.com
    }
    
    func getSourceNameForArticle(atIndex index: Int) -> String {
        return articles?[index].sourceName ?? "Источник не определен"
    }
    
    func getPublishingDataForArticle(atIndex index: Int) -> String {
        return articles?[index].publishedAt ?? "Дата не определена"
    }
    
    func clearCache() {
        cacheManager.clearCache()
    }
    
    // MARK: Private Methods
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
    
    // Save articles to UserDefaults
    private func saveArticles() {
        if let articles = self.articles {
            let encodedArticles = try? JSONEncoder().encode(articles)
            UserDefaults.standard.set(encodedArticles, forKey: "SavedArticles")
        }
    }

    // Load articles from UserDefaults
    private func loadArticles() {
        if let encodedArticles = UserDefaults.standard.data(forKey: "SavedArticles") {
            let decodedArticles = try? JSONDecoder().decode([Article].self, from: encodedArticles)
            self.articles = decodedArticles
            self.onDataUpdate?()
        }
    }
    
}
