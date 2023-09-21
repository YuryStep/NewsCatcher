//
//  DataManager.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

import Foundation

protocol AppDataManager {
    var onDataUpdate: (() -> Void)? { get set }
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

protocol ArticleSearchCriteria {
    var articleLanguage: String { get }
    var publicationCountry: String { get }
    var searchPlaces: String { get }
    var sortedBy: String { get }
}

final class DataManager: AppDataManager {
    // MARK: Dependencies

    static let shared = DataManager(
        repository: NewsRepository(
            networkService: NetworkService(apiRequestBuilder: APIRequestBuilder()),
            cacheService: CacheService()
        )
    )

    // MARK: Dependencies

    private let repository: AppDataRepository
    var onDataUpdate: (() -> Void)?

    // MARK: Initializer

    private init(repository: AppDataRepository) {
        self.repository = repository
        repository.getInitialFeed { [weak self] in
            guard let self else { return }
            onDataUpdate?()
        }
    }

    // MARK: AppDataManager API

    func downloadNews(about keyword: String?, searchCriteria: ArticleSearchCriteria?, completion: @escaping ((Result<Void, NetworkError>) -> Void)) {
        repository.downloadNews(about: keyword, searchCriteria: searchCriteria) { result in
            switch result {
            case .success: completion(.success(()))
            case let .failure(error): completion(.failure(error))
            }
        }
    }

    func getNumberOfArticles() -> Int {
        repository.getNumberOfArticles()
    }

    func getTitleForArticle(at index: Int) -> String {
        repository.getTitleForArticle(at: index)
    }

    func getDescriptionForArticle(at index: Int) -> String {
        repository.getDescriptionForArticle(at: index)
    }

    func getContentForArticle(at index: Int) -> String {
        repository.getContentForArticle(at: index)
    }

    func getImageDataForArticle(at index: Int, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        repository.getImageDataForArticle(at: index, completion: completion)
    }

    func getSourceURLForArticle(at index: Int) -> String {
        repository.getSourceURLForArticle(at: index)
    }

    func getSourceNameForArticle(at index: Int) -> String {
        repository.getSourceNameForArticle(at: index)
    }

    func getPublishingDateForArticle(at index: Int) -> String {
        repository.getPublishingDateForArticle(at: index)
    }

    func clearCache() {
        repository.clearCache()
    }
}
