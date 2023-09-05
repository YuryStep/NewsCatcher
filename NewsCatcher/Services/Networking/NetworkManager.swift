//
//  NetworkManager.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

import Foundation

protocol AppNetworkManager {
    func downloadNews(about: String?, usingSearchCriteria: ArticleSearchCriteria?, completion: @escaping ([AppArticle])->())
    func downloadData(from url: String, completion: @escaping (Data?) -> ())
}

class NetworkManager: AppNetworkManager {
    private let apiRequestBuilder: AppRequestBuilder
    
    init(apiRequestBuilder: AppRequestBuilder) {
        self.apiRequestBuilder = apiRequestBuilder
    }
    
    //  MARK: Public API
    func downloadNews(about searchPhrase: String?, usingSearchCriteria searchCriteria: ArticleSearchCriteria?, completion: @escaping ([AppArticle])->()) {
        let apiRequestString = apiRequestBuilder.getURLRequestString(usingSearchPhrase: searchPhrase, searchCriterias: searchCriteria)
        fetchData(from: apiRequestString) { [weak self] jsonData in
            guard let self = self else { return }
            self.decodeJSON(from: jsonData) { gNews in
                completion(gNews.articles)
            }
        }
    }
    
    func downloadData(from url: String, completion: @escaping (Data?) -> ()) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                completion(data)
            }
        }
        dataTask.resume()
    }
    
    // MARK: Private Methods
    private func fetchData(from url: String, completion: @escaping(Data)->()) {
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            completion(data)
        }
        task.resume()
    }
    
    private func decodeJSON(from data: Data, completion: @escaping (GNews)->() ) {
        let decoder = JSONDecoder()
        do {
            let news = try decoder.decode(GNews.self, from: data)
            completion(news)
        } catch {
            print(error)
        }
    }
    
}
