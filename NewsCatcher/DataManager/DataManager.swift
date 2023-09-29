//
//  DataManager.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

import Foundation

protocol AppDataManager {
    func getCurrentNews(completion: @escaping ((Result<[Article], NetworkError>) -> Void))
    func getNews(about: String?, completion: @escaping ((Result<[Article], NetworkError>) -> Void))
    func getImageData(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
    func clearCache()
}

final class DataManager: AppDataManager {
    private enum Constants {
        static let cachedArticlesKey = "SavedArticles"
    }

    static let shared = DataManager(
        networkService: NetworkService(apiRequestBuilder: APIRequestBuilder()),
        cacheService: CacheService()
    )

    private let networkService: AppNetworkService
    private let cacheService: AppCacheService
    private var requestSettings: SearchCriteria?

    private init(networkService: AppNetworkService, cacheService: AppCacheService) {
        self.networkService = networkService
        self.cacheService = cacheService
        requestSettings = getInitialRequestSettings()
    }

    func getCurrentNews(completion: @escaping ((Result<[Article], NetworkError>) -> Void)) {
        if let cachedArticles = cacheService.getArticles(forKey: Constants.cachedArticlesKey) {
            completion(.success(cachedArticles))
        } else {
            downloadNews(about: nil) { downloadingResult in
                completion(downloadingResult)
            }
        }
    }

    func getNews(about keyword: String?, completion: @escaping ((Result<[Article], NetworkError>) -> Void)) {
        downloadNews(about: keyword) { result in
            completion(result)
        }
    }

    func getImageData(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        downloadImageData(from: urlString) { result in
            completion(result)
        }
    }

    func clearCache() {
        cacheService.clearCache()
    }
}

extension DataManager {
    private func downloadNews(about keyword: String?, completion: @escaping ((Result<[Article], NetworkError>) -> Void)) {
        networkService.downloadArticles(about: keyword, searchCriteria: requestSettings) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(articles):
                if !articles.isEmpty {
                    cacheService.save(articles: articles, forKey: Constants.cachedArticlesKey)
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

    private func getInitialRequestSettings() -> SearchCriteria {
        // TODO: Add loading from user defaults
        return RequestSettings()
    }
}
