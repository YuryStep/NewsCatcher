//
//  PersistenceService.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import Foundation

protocol AppPersistenceService {
    func saveData(_: Data, forKey key: String)
    func getData(forKey key: String) -> Data?
    func save<T: Encodable>(_: T, forKey key: String)
    func readValue<T: Decodable>(forKey key: String) -> T?
    func saveArticle(_ article: Article, forKey key: String)
    func removeArticle(_ article: Article, forKey key: String)
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

    func saveData(_ data: Data, forKey key: String) {
        let data = data as NSData
        let key = key as NSString
        cache.setObject(data, forKey: key)
    }

    func save<T: Encodable>(_ object: T, forKey key: String) {
        if let encodedObject = try? JSONEncoder().encode(object) {
            UserDefaults.standard.set(encodedObject, forKey: key)
        }
    }

    func readValue<T: Decodable>(forKey key: String) -> T? {
        guard let encodedObject = UserDefaults.standard.data(forKey: key),
              let decodedObject = try? JSONDecoder().decode(T.self, from: encodedObject)
        else { return nil }
        return decodedObject
    }

    func saveArticle(_ article: Article, forKey key: String) {
        var savedArticles = getSavedArticles(forKey: key) ?? []
        guard !savedArticles.contains(where: { $0.id == article.id }) else { return }
        savedArticles.append(article)
        if let encodedArticles = try? JSONEncoder().encode(savedArticles) {
            UserDefaults.standard.set(encodedArticles, forKey: key)
        }
    }

    func removeArticle(_ article: Article, forKey key: String) {
        let savedArticles = getSavedArticles(forKey: key) ?? []
        let filteredArticles = savedArticles.filter { $0.id != article.id }
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
