//
//  PersistenceService.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import Foundation

protocol AppPersistenceService {
    func save(_: Data, forKey: String)
    func getData(forKey: String) -> Data?
    func saveFeed(_ articles: [Article], forKey: String)
    func getFeed(forKey: String) -> [Article]?
    func save(_: SearchSettings, forKey: String)
    func getSearchSettings(forKey: String) -> SearchSettings?
    func saveArticle(_ article: Article, forKey: String)
    func removeArticle(_ article: Article, forKey: String)
    func getSavedArticles(forKey key: String) -> [Article]?
    func clearCache()
}

final class PersistenceService: AppPersistenceService {
    private let cache = NSCache<NSString, NSData>()

    func getData(forKey key: String) -> Data? {
        let key = key as NSString
        if let cachedData = cache.object(forKey: key) {
            return cachedData as Data
        }
        return nil
    }

    func save(_ data: Data, forKey key: String) {
        let data = data as NSData
        let key = key as NSString
        cache.setObject(data, forKey: key)
    }

    func getFeed(forKey key: String) -> [Article]? {
        guard let encodedArticles = UserDefaults.standard.data(forKey: key),
              let decodedArticles = try? JSONDecoder().decode([Article].self, from: encodedArticles)
        else { return nil }
        return decodedArticles
    }

    func saveFeed(_ articles: [Article], forKey key: String) {
        if let encodedArticles = try? JSONEncoder().encode(articles) {
            UserDefaults.standard.set(encodedArticles, forKey: key)
        }
    }

    func save(_ settings: SearchSettings, forKey key: String) {
        if let encodedSettings = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encodedSettings, forKey: key)
        }
    }

    func getSearchSettings(forKey key: String) -> SearchSettings? {
        guard let encodedSettings = UserDefaults.standard.data(forKey: key),
              let decodedSettings = try? JSONDecoder().decode(SearchSettings.self, from: encodedSettings)
        else { return nil }
        return decodedSettings
    }

    func saveArticle(_ article: Article, forKey key: String) {
        var savedArticles = getSavedArticles(forKey: key) ?? []
        guard !savedArticles.contains(where: { $0.urlString == article.urlString }) else { return }
        savedArticles.append(article)
        if let encodedArticles = try? JSONEncoder().encode(savedArticles) {
            UserDefaults.standard.set(encodedArticles, forKey: key)
        }
    }

    func removeArticle(_ article: Article, forKey key: String) {
        let savedArticles = getSavedArticles(forKey: key) ?? []
        let filteredArticles = savedArticles.filter { $0.urlString != article.urlString }
        if let encodedArticles = try? JSONEncoder().encode(filteredArticles) {
            UserDefaults.standard.set(encodedArticles, forKey: key)
        }
    }

    func getSavedArticles(forKey key: String) -> [Article]? {
        guard let encodedArticles = UserDefaults.standard.data(forKey: key),
              let decodedArticles = try? JSONDecoder().decode([Article].self, from: encodedArticles)
        else { return nil }
        return decodedArticles
    }

    func clearCache() {
        cache.removeAllObjects()
    }
}
