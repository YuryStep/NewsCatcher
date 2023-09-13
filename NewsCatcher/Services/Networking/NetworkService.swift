//
//  NetworkService.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

import Foundation

protocol AppNetworkService {
    func downloadArticles(about: String?, searchCriteria: ArticleSearchCriteria?, completion: @escaping ([AppArticle]) -> Void)
    func downloadData(from url: String, completion: @escaping (Data?) -> Void)
}

final class NetworkService: AppNetworkService {
    private let apiRequestBuilder: AppRequestBuilder

    // MARK: Initializer

    init(apiRequestBuilder: AppRequestBuilder) {
        self.apiRequestBuilder = apiRequestBuilder
    }

    // MARK: AppNetworkManager

    func downloadArticles(about keyPhrase: String?, searchCriteria: ArticleSearchCriteria?, completion: @escaping ([AppArticle]) -> Void) {
        let urlRequestString = apiRequestBuilder.getURLRequestString(for: keyPhrase, searchCriteria: searchCriteria)
        fetchData(from: urlRequestString) { [weak self] jsonData in
            guard let self = self else { return }
            self.decodeJSON(from: jsonData) { gNews in
                DispatchQueue.main.async {
                    completion(gNews.articles)
                }
            }
        }
    }

    func downloadData(from url: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    completion(data)
                }
            }
        }
        dataTask.resume()
    }

    // MARK: Private Methods

    private func fetchData(from url: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            completion(data)
        }
        task.resume()
    }

    private func decodeJSON(from data: Data, completion: @escaping (GNews) -> Void) {
        let decoder = JSONDecoder()
        do {
            let news = try decoder.decode(GNews.self, from: data)
            completion(news)
        } catch {
            print(error)
        }
    }
}
