//
//  NetworkManager.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

import Foundation

protocol AppNetworkManager {
    func downloadNews(about: String?, completion: @escaping (GNews)->())
    func downloadData(from url: String, completion: @escaping (Data?) -> ())
}

class NetworkManager: AppNetworkManager {
    private let testAPI = "https://gnews.io/api/v4/search?q=example&lang=en&country=us&max=10&apikey=05119a9d9eec92db2c653876cf3e015c"
    
    //  MARK: Public API
    func downloadNews(about keyword: String?, completion: @escaping (GNews)->()) {
        fetchData(from: testAPI) { [weak self] jsonData in
            guard let self = self else { return }
            self.decodeJSON(from: jsonData) { gNews in
                completion(gNews)
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
