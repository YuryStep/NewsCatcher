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

    func getArticles(forKey: String) -> [Article]?
    func save(articles: [Article], forKey: String)

    func clearCache()
}

final class CacheService: AppCacheService {
    private let userDefaults: UserDefaults
    private let articlesDecoder: JSONDecoder
    private let articlesEncoder: JSONEncoder
    private let cache: NSCache<NSString, NSData>

    init() {
        userDefaults = UserDefaults.standard
        articlesDecoder = JSONDecoder()
        articlesEncoder = JSONEncoder()
        cache = NSCache<NSString, NSData>()
    }

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
        guard let encodedArticles = userDefaults.data(forKey: key),
              let decodedArticles = try? articlesDecoder.decode([Article].self, from: encodedArticles)
        else { return nil }
        return decodedArticles
    }

    func save(articles: [Article], forKey key: String) {
        if let encodedArticles = try? articlesEncoder.encode(articles) {
            userDefaults.set(encodedArticles, forKey: key)
        }
    }

    func clearCache() {
        cache.removeAllObjects()
    }
}
