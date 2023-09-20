//
//  NewsRepository.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 14.09.2023.
//

import Foundation

protocol AppDataRepository {
    func getInitialFeed(completion: @escaping () -> Void)
    func downloadNews(about: String?, searchCriteria: ArticleSearchCriteria?, completion: @escaping ((Result<Void, NetworkError>) -> Void))
    func getNumberOfArticles() -> Int
    func getTitleForArticle(at index: Int) -> String
    func getDescriptionForArticle(at index: Int) -> String
    func getContentForArticle(at index: Int) -> String
    func getImageDataForArticle(at index: Int, completion: @escaping (Result<Data, NetworkError>) -> Void)
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

    private var articles = [Article]()

    // MARK: Initializer

    init(networkService: AppNetworkService, cacheService: AppCacheService) {
        self.networkService = networkService
        self.cacheService = cacheService
    }

    // MARK: DataRepository

    func getInitialFeed(completion: @escaping () -> Void) {
        if let cachedArticles = cacheService.getArticles(forKey: Constants.articlesCacheKey) {
            articles = cachedArticles
        } else {
            downloadNews(about: nil, searchCriteria: nil) { _ in
                completion()
            }
        }
    }

    func downloadNews(about keyword: String?, searchCriteria: ArticleSearchCriteria?, completion: @escaping ((Result<Void, NetworkError>) -> Void)) {
        networkService.downloadArticles(about: keyword, searchCriteria: searchCriteria) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(articles):
                if !articles.isEmpty {
                    self.articles = articles
                    cacheService.save(articles: articles, forKey: Constants.articlesCacheKey)
                    completion(.success(()))
                } else {
                    completion(.failure(.noArticlesFound))
                }
            case let .failure(error):
                completion(.failure(error))
            }
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

    func getImageDataForArticle(at index: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let imageURL = articles[index].imageStringURL
        if let imageData = cacheService.getData(forKey: imageURL) {
            completion(.success(imageData))
        } else {
            networkService.downloadImageData(from: imageURL) { response in
                switch response {
                case let .success(imageData):
                    self.cacheService.save(imageData, forKey: imageURL)
                    completion(.success(imageData))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }

    func getSourceURLForArticle(at index: Int) -> String {
        articles[index].source.url
    }

    func getSourceNameForArticle(at index: Int) -> String {
        articles[index].source.name
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
}
