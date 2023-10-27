//
//  DataManager.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

import Foundation

protocol AppDataManager {
    var searchSettings: SearchSettings { get set }
    func getCurrentNews(completion: @escaping ((Result<[Article], NetworkError>) -> Void))
    func getNews(about: String?, completion: @escaping ((Result<[Article], NetworkError>) -> Void))
    func getImageData(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
    func saveArticle(_: Article)
    func deleteArticle(_: Article)
    func clearCache()
}

final class DataManager: AppDataManager {
    private enum Constants {
        static let cachedFeedArticlesKey = "cachedFeedArticles"
        static let cachedSearchSettingsKey = "cachedSearchSettings"
    }

    static let shared = DataManager(
        networkService: NetworkService(apiRequestBuilder: APIRequestBuilder()),
        cacheService: CacheService()
    )

    private let networkService: AppNetworkService
    private let cacheService: AppCacheService

    var searchSettings: SearchSettings {
        didSet { cacheService.save(searchSettings, forKey: Constants.cachedSearchSettingsKey) }
    }

    private init(networkService: AppNetworkService, cacheService: AppCacheService) {
        self.networkService = networkService
        self.cacheService = cacheService
        searchSettings = SearchSettings()
        setInitialSearchSettings()
    }

    func getCurrentNews(completion: @escaping ((Result<[Article], NetworkError>) -> Void)) {
        if let cachedArticles = cacheService.getArticles(forKey: Constants.cachedFeedArticlesKey) {
            completion(.success(cachedArticles))
        } else {
            let request = makeActualRequest(forKeyword: nil)
            downloadNews(using: request) { downloadingResult in
                completion(downloadingResult)
            }
        }
    }

    func getNews(about keyword: String?, completion: @escaping ((Result<[Article], NetworkError>) -> Void)) {
        let request = makeActualRequest(forKeyword: keyword)
        downloadNews(using: request) { result in
            completion(result)
        }
    }

    func getImageData(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        downloadImageData(from: urlString) { result in
            completion(result)
        }
    }

    func saveArticle(_ article: Article) {
        print("Article with url \(article.urlString) is saved in Memory")
    }

    func deleteArticle(_ article: Article) {
        print("Article with url \(article.urlString) is Removed from Memory")
    }

    func clearCache() {
        cacheService.clearCache()
    }
}

extension DataManager {
    private func downloadNews(using request: Request, completion: @escaping ((Result<[Article], NetworkError>) -> Void)) {
        networkService.downloadArticles(using: request) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(articles):
                if !articles.isEmpty {
                    cacheService.save(articles: articles, forKey: Constants.cachedFeedArticlesKey)
                }
                completion(.success(articles))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func downloadImageData(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let imageData = cacheService.getData(forKey: urlString) else {
            networkService.downloadImageData(from: urlString) { response in
                switch response {
                case let .success(imageData):
                    self.cacheService.save(imageData, forKey: urlString)
                    completion(.success(imageData))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
            return
        }
        completion(.success(imageData))
    }

    private func makeActualRequest(forKeyword keyword: String?) -> Request {
        guard let keyword = keyword else { return Request(settings: searchSettings) }
        return Request(settings: searchSettings, keyword: keyword)
    }

    private func setInitialSearchSettings() {
        searchSettings = cacheService.getSearchSettings(forKey: Constants.cachedSearchSettingsKey) ?? SearchSettings()
    }
}
