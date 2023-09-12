//
//  DataManagerAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 08.09.2023.
//

enum DataManagerAssembly {
    static func makeModule() -> AppDataManager {
        let apiBuilder = APIRequestBuilder()
        let networkService = NetworkService(apiRequestBuilder: apiBuilder)
        let cacheService = CacheService()
        let dataManager = DataManager<GNews.Article>(networkService: networkService, cacheService: cacheService)
        return dataManager
    }
}
