//
//  DataManager.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

import Foundation

protocol AppDataManager {
    var onDataUpdate: (() -> Void)? { get set }
    func downloadNews(about: String?, searchCriteria: ArticleSearchCriteria?)
    func getNumberOfArticles() -> Int
    func getTitleForArticle(at index: Int) -> String
    func getDescriptionForArticle(at index: Int) -> String
    func getContentForArticle(at index: Int) -> String
    func getImageDataForArticle(at index: Int, completion: @escaping (Data?) -> Void)
    func getSourceURLForArticle(at index: Int) -> String
    func getSourceNameForArticle(at index: Int) -> String
    func getPublishingDateForArticle(at index: Int) -> String
    func clearCache()
}

protocol ArticleSearchCriteria {
    var articleLanguage: String { get }
    var publicationCountry: String { get }
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

final class DataManager<Article: AppArticle>: AppDataManager {
    // MARK: Dependencies

    private let networkService: AppNetworkService
    private let cacheService: AppCacheService
    private var articles = [Article]()
    var onDataUpdate: (() -> Void)?

    // MARK: Initializer

    init(networkService: AppNetworkService, cacheService: AppCacheService) {
        self.networkService = networkService
        self.cacheService = cacheService
        loadArticlesFromUserDefaults()
        if articles.isEmpty {
            downloadNews(about: nil, searchCriteria: nil)
        }
    }

    // MARK: AppDataManager

    func downloadNews(about keyword: String?, searchCriteria: ArticleSearchCriteria?) {
        networkService.downloadArticles(about: keyword, searchCriteria: searchCriteria) { [weak self] appArticles in
            let articles = appArticles.compactMap { $0 as? Article }
            self?.articles = articles
            self?.saveArticlesToUserDefaults()
            self?.onDataUpdate?()
        }
    }

    func getNumberOfArticles() -> Int {
        return articles.count
    }

    func getTitleForArticle(at index: Int) -> String {
        return articles[index].title
    }

    func getDescriptionForArticle(at index: Int) -> String {
        return articles[index].description
    }

    func getContentForArticle(at index: Int) -> String {
        return articles[index].content
    }

    func getImageDataForArticle(at index: Int, completion: @escaping (Data?) -> Void) {
        return getImageData(forArticle: articles[index], completion: completion)
    }

    func getSourceURLForArticle(at index: Int) -> String {
        return articles[index].url
    }

    func getSourceNameForArticle(at index: Int) -> String {
        return articles[index].sourceName
    }

    func getPublishingDateForArticle(at index: Int) -> String {
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
        cacheService.clearCache()
    }

    // MARK: Private Methods

    private func getImageData(forArticle article: Article, completion: @escaping (Data?) -> Void) {
        let imageURL = article.image
        if let imageData = cacheService.getData(forKey: imageURL) {
            completion(imageData)
        } else {
            networkService.downloadData(from: imageURL) { imageData in
                guard let imageData = imageData else { return }
                self.cacheService.save(imageData, forKey: imageURL)
                completion(imageData)
            }
        }
    }

    private func saveArticlesToUserDefaults() {
        let encodedArticles = try? JSONEncoder().encode(articles)
        UserDefaults.standard.set(encodedArticles, forKey: "SavedArticles")
    }

    private func loadArticlesFromUserDefaults() {
        if let encodedArticles = UserDefaults.standard.data(forKey: "SavedArticles") {
            let decodedArticles = try? JSONDecoder().decode([Article].self, from: encodedArticles)
            articles = decodedArticles!
            onDataUpdate?()
        }
    }
}
