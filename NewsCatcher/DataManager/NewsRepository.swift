//
//  NewsRepository.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 14.09.2023.
//

import Foundation

protocol AppDataRepository {
    func getInitialFeed(completion: @escaping () -> Void)
    func downloadNews(about: String?, searchCriteria: ArticleSearchCriteria?, completion: @escaping () -> Void)
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

final class NewsRepository: AppDataRepository {
    private enum Constants {
        static let articlesCacheKey = "Saved NCArticles"
        static let publishingDateFormat = "yyyy-MM-dd"
    }

    // MARK: Dependencies

    private let networkService: AppNetworkService
    private let cacheService: AppCacheService

    // MARK: Data

    private var articles = [NCArticle]()

    // MARK: Initializer

    init(networkService: AppNetworkService, cacheService: AppCacheService) {
        self.networkService = networkService
        self.cacheService = cacheService
    }

    // MARK: DataRepository

    func getInitialFeed(completion: @escaping () -> Void) {
        articles = cacheService.getArticles(forKey: Constants.articlesCacheKey)
        if articles.isEmpty {
            downloadNews(about: nil, searchCriteria: nil) { completion() }
        }
    }

    func downloadNews(about keyword: String?, searchCriteria: ArticleSearchCriteria?, completion: @escaping () -> Void) {
        networkService.downloadArticles(about: keyword, searchCriteria: searchCriteria) { [weak self] appArticles in
            let ncArticles = self?.getNCArticles(from: appArticles) ?? [NCArticle]()
            self?.articles = ncArticles
            self?.cacheService.save(articles: ncArticles, forKey: Constants.articlesCacheKey)
            completion()
        }
    }

    func getNumberOfArticles() -> Int {
        articles.count
    }

    func getTitleForArticle(at index: Int) -> String {
        articles[index].title
    }

    func getDescriptionForArticle(at index: Int) -> String {
        articles[index].description
    }

    func getContentForArticle(at index: Int) -> String {
        articles[index].content
    }

    func getImageDataForArticle(at index: Int, completion: @escaping (Data?) -> Void) {
        let imageURL = articles[index].imageURL
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

    func getSourceURLForArticle(at index: Int) -> String {
        articles[index].url
    }

    func getSourceNameForArticle(at index: Int) -> String {
        articles[index].sourceName
    }

    func getPublishingDateForArticle(at index: Int) -> String {
        let dateString = articles[index].publishedAt
        if let date = ISO8601DateFormatter().date(from: dateString) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.publishingDateFormat
            return dateFormatter.string(from: date)
        } else {
            return dateString
        }
    }

    func clearCache() {
        cacheService.clearCache()
    }

    // MARK: Private Methods

    private func getNCArticles(from rowArticles: [AppArticle]) -> [NCArticle] {
        var feedNews = [NCArticle]()
        rowArticles.forEach { rowArticle in
            let ncArticle = NCArticle(
                title: rowArticle.title,
                description: rowArticle.description,
                content: rowArticle.content,
                url: rowArticle.url,
                imageURL: rowArticle.imageURL,
                publishedAt: rowArticle.publishedAt,
                sourceName: rowArticle.sourceName
            )
            feedNews.append(ncArticle)
        }
        return feedNews
    }
}
