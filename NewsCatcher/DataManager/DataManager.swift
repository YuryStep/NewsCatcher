//
//  DataManager.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

import Foundation

protocol AppDataManager {
    func getCurrentSearchSettings() -> SearchSettings
    func setSearchSettings(_: SearchSettings)
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
    private var searchSettings: SearchSettings!
    private var request: Request!

    private init(networkService: AppNetworkService, cacheService: AppCacheService) {
        self.networkService = networkService
        self.cacheService = cacheService
        searchSettings = getInitialSearchSettings()
        request = Request(settings: searchSettings)
    }

    func getCurrentSearchSettings() -> SearchSettings {
        return searchSettings
    }

    func setSearchSettings(_ newSettings: SearchSettings) {
        searchSettings = newSettings
    }

    func getCurrentNews(completion: @escaping ((Result<[Article], NetworkError>) -> Void)) {
        if let cachedArticles = cacheService.getArticles(forKey: Constants.cachedArticlesKey) {
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

    private func makeActualRequest(forKeyword keyword: String?) -> Request {
        if let keyword = keyword {
            return Request(settings: searchSettings, keyword: keyword)
        } else {
            return Request(settings: searchSettings)
        }
    }

    private func getInitialSearchSettings() -> SearchSettings {
        // TODO: Add loading from user defaults
        return SearchSettings()
    }
}
