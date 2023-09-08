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
    func getPublishingDateForArticle(atIndex: Int) -> String
    func clearCache()
    var onDataUpdate: (() -> ())? { get set }
}

protocol ArticleSearchCriteria {
    var articleLanguage: String { get }
    var articlePublicationCountry: String { get }
    var searchPlaces: String { get }
    var sortedBy: String { get }
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
    
    // MARK: Dependencies
    private let networkManager: AppNetworkManager
    private let cacheManager: AppCacheManager
    
    private var articles = [Article]()
    var onDataUpdate: (() -> ())?
    
    // MARK: Initializer
    init(networkManager: AppNetworkManager, cacheManager: AppCacheManager) {
        self.networkManager = networkManager
        self.cacheManager = cacheManager
        loadArticlesfromUserDefaults()
        if articles.isEmpty {
            downloadNews(about: nil, searchCriteria: nil)
        }
    }
    
    // MARK: Public API
    func downloadNews(about keyward: String?, searchCriteria: ArticleSearchCriteria?) {
        networkManager.downloadNews(about: keyward, usingSearchCriteria: searchCriteria) { [weak self] appArticles in
            let articles = appArticles.compactMap { $0 as? Article }
            self?.articles = articles
            self?.saveArticlestoUserDefaults()
            self?.onDataUpdate?()
        }
    }
    
    func getNumberOfArticles() -> Int {
        return articles.count
    }
    
    func getTitleForArticle(atIndex index: Int) -> String {
        return articles[index].title
    }
    
    func getDescriptionForArticle(atIndex index: Int) -> String {
        return articles[index].description
    }
    
    func getContentForArticle(atIndex index: Int) -> String {
        return articles[index].content
    }
    
    func getImageDataforArticle(atIndex index: Int, completion: @escaping (Data?) -> Void) {
        return getImageData(forArticle: articles[index], completion: completion)
    }
    
    func getSourceURLforArticle(atIndex index: Int) -> String {
        return articles[index].url
    }
    
    func getSourceNameForArticle(atIndex index: Int) -> String {
        return articles[index].sourceName
    }
    
    func getPublishingDateForArticle(atIndex index: Int) -> String {
        let dateString = articles[index].publishedAt
        if let date = ISO8601DateFormatter().date(from: dateString) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        } else {
            return dateString
        }
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
    
    private func saveArticlestoUserDefaults() {
            let encodedArticles = try? JSONEncoder().encode(articles)
            UserDefaults.standard.set(encodedArticles, forKey: "SavedArticles")
    }

    private func loadArticlesfromUserDefaults() {
        if let encodedArticles = UserDefaults.standard.data(forKey: "SavedArticles") {
            let decodedArticles = try? JSONDecoder().decode([Article].self, from: encodedArticles)
            self.articles = decodedArticles!
            self.onDataUpdate?()
        }
    }
    
}
