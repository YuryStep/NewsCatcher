//
//  CacheService.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import Foundation

protocol AppCacheService {
    func save(_: Data, forKey: String)
    func getData(forKey: String) -> Data?
    func save(articles: [Article], forKey: String)
    func getArticles(forKey: String) -> [Article]?
    func save(_: SearchSettings, forKey: String)
    func getSearchSettings(forKey: String) -> SearchSettings?
    func clearCache()
}

final class CacheService: AppCacheService {
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

    func getArticles(forKey key: String) -> [Article]? {
        guard let encodedArticles = UserDefaults.standard.data(forKey: key),
              let decodedArticles = try? JSONDecoder().decode([Article].self, from: encodedArticles)
        else { return nil }
        return decodedArticles
    }

    func save(articles: [Article], forKey key: String) {
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

    func clearCache() {
        cache.removeAllObjects()
    }
}
