//
//  DataManagerAssembly.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 08.09.2023.
//

class DataManagerAssembly {
    class func configureModule() -> AppDataManager {
        let apiBuilder = APIRequestBuilder()
        let networkManager = NetworkManager(apiRequestBuilder: apiBuilder)
        let cacheManager = CacheManager()
        let dataManager = DataManager<GNews.Article>(networkManager: networkManager, cacheManager: cacheManager)
        return dataManager
    }
}
