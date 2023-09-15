//
//  CacheService.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import Foundation

protocol AppCacheService {
    func getData(forKey: String) -> Data?
    func save(_: Data, forKey: String)

    func getArticles(forKey: String) -> [NCArticle]
    func save(articles: [NCArticle], forKey: String)

    func clearCache()
}

final class CacheService: AppCacheService {
    private let cache = NSCache<NSString, NSData>()

    // MARK: Data Saving

    func getData(forKey key: String) -> Data? {
        let nsKey = key as NSString
        if let cachedData = cache.object(forKey: nsKey) {
            return cachedData as Data
        }
        return nil
    }

    func save(_ data: Data, forKey key: String) {
        let nsData = data as NSData
        let nsKey = key as NSString
        cache.setObject(nsData, forKey: nsKey)
    }

    // MARK: Articles Saving

    func getArticles(forKey key: String) -> [NCArticle] {
        var articles = [NCArticle]()
        if let encodedArticles = UserDefaults.standard.data(forKey: key) {
            let decodedArticles = try? JSONDecoder().decode([NCArticle].self, from: encodedArticles)
            articles = decodedArticles ?? [NCArticle]()
        }
        return articles
    }

    func save(articles: [NCArticle], forKey key: String) {
        do {
            let encodedArticles = try JSONEncoder().encode(articles)
            UserDefaults.standard.set(encodedArticles, forKey: key)
        } catch {
            debugPrint("Error when encoding articles in JSON: \(error)")
        }
    }

    // MARK: Clear Cache

    func clearCache() {
        cache.removeAllObjects()
    }
}
