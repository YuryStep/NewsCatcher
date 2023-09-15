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

final class DataManager: AppDataManager {
    // MARK: Dependencies

    private let repository: ArticlesRepository
    var onDataUpdate: (() -> Void)?

    // MARK: Initializer

    init(repository: ArticlesRepository) {
        self.repository = repository
        repository.getInitialFeed { [weak self] in
            self?.onDataUpdate?()
        }
    }

    // MARK: AppDataManager API

    func downloadNews(about keyword: String?, searchCriteria: ArticleSearchCriteria?) {
        repository.downloadNews(about: keyword, searchCriteria: searchCriteria) { [weak self] in
            self?.onDataUpdate?()
        }
    }

    func getNumberOfArticles() -> Int {
        repository.articles.count
    }

    func getTitleForArticle(at index: Int) -> String {
        repository.articles[index].title
    }

    func getDescriptionForArticle(at index: Int) -> String {
        repository.articles[index].description
    }

    func getContentForArticle(at index: Int) -> String {
        repository.articles[index].content
    }

    func getImageDataForArticle(at index: Int, completion: @escaping (Data?) -> Void) {
        repository.getImageDataForArticle(at: index, completion: completion)
    }

    func getSourceURLForArticle(at index: Int) -> String {
        repository.articles[index].url
    }

    func getSourceNameForArticle(at index: Int) -> String {
        repository.articles[index].sourceName
    }

    func getPublishingDateForArticle(at index: Int) -> String {
        repository.getPublishingDateForArticle(at: index)
    }

    func clearCache() {
        repository.clearCache()
    }
}
