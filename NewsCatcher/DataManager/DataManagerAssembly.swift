//
//  DataManagerAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 08.09.2023.
//

enum DataManagerAssembly {
    static func makeModule() -> AppDataManager {
        DataManager<GNews.Article>(
            networkService: NetworkService(apiRequestBuilder: APIRequestBuilder()),
            cacheService: CacheService()
        )
    }

}
