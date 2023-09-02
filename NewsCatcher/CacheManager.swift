//
//  CacheManager.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import Foundation

class CacheManager {
    private let cache = NSCache<NSString, NSData>()
    
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

    func clearCache() {
        cache.removeAllObjects()
    }
}
