//
//  DataManager.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

import Foundation

protocol AppDataManager {
    func getCurrentNews(completion: @escaping ((Result<[Article], NetworkError>) -> Void))
    func getNews(about: String?, searchCriteria: SearchCriteria?, completion: @escaping ((Result<[Article], NetworkError>) -> Void))
    func getImageData(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
    func clearCache()
}

protocol SearchCriteria {
    var articleLanguage: String { get }
    var publicationCountry: String { get }
    var searchPlaces: String { get }
    var sortedBy: String { get }
}

final class DataManager: AppDataManager {
    private enum Constants {
        static let cachedArticlesKey = "Saved NCArticles"
    }

    static let shared = DataManager(
        networkService: NetworkService(apiRequestBuilder: APIRequestBuilder()),
        cacheService: CacheService()
    )

    private let networkService: AppNetworkService
    private let cacheService: AppCacheService

    private init(networkService: AppNetworkService, cacheService: AppCacheService) {
        self.networkService = networkService
        self.cacheService = cacheService
    }

    func getCurrentNews(completion: @escaping ((Result<[Article], NetworkError>) -> Void)) {
        if let cachedArticles = cacheService.getArticles(forKey: Constants.cachedArticlesKey) {
            completion(.success(cachedArticles))
        } else {
            downloadNews(about: nil, searchCriteria: nil) { downloadingResult in
                completion(downloadingResult)
            }
        }
    }

    func getNews(about keyword: String?, searchCriteria: SearchCriteria?, completion: @escaping ((Result<[Article], NetworkError>) -> Void)) {
        downloadNews(about: keyword, searchCriteria: searchCriteria) { result in
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
    private func downloadNews(about keyword: String?, searchCriteria: SearchCriteria?, completion: @escaping ((Result<[Article], NetworkError>) -> Void)) {
        networkService.downloadArticles(about: keyword, searchCriteria: searchCriteria) { [weak self] result in
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
        if let imageData = cacheService.getData(forKey: urlString) {
            completion(.success(imageData))
        } else {
            networkService.downloadImageData(from: urlString) { response in
                switch response {
                case let .success(imageData):
                    self.cacheService.save(imageData, forKey: urlString)
                    completion(.success(imageData))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
}
