//
//  NetworkService.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

import Foundation

protocol AppNetworkService {
    func downloadArticles(about: String?, searchCriteria: ArticleSearchCriteria?, completion: @escaping ((Result<[Article], NetworkError>) -> Void))
    func downloadImageData(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

final class NetworkService: AppNetworkService {
    private let apiRequestBuilder: AppRequestBuilder

    // MARK: Initializer

    init(apiRequestBuilder: AppRequestBuilder) {
        self.apiRequestBuilder = apiRequestBuilder
    }

    // MARK: AppNetworkManager

    func downloadArticles(about keyPhrase: String?, searchCriteria: ArticleSearchCriteria?, completion: @escaping (Result<[Article], NetworkError>) -> Void) {
        let urlRequestString = apiRequestBuilder.getURLRequestString(for: keyPhrase, searchCriteria: searchCriteria)
        fetchData(from: urlRequestString) { [weak self] dataFetchingResult in
            guard let self else { return }

            switch dataFetchingResult {
            case let .success(data):
                parseNews(from: data) { decodingResult in
                    DispatchQueue.main.async {
                        switch decodingResult {
                        case let .success(news):
                            completion(.success(news.articles))
                        case let .failure(error):
                            completion(.failure(error))
                        }
                    }
                }
            case let .failure(error):
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }

    func downloadImageData(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        fetchData(from: urlString) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(imageData):
                    completion(.success(imageData))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }

    // MARK: Private Methods

    private func fetchData(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                self.handleNetworkError(error, completion)
            } else {
                self.handleHTTPResponse(response, data, completion)
            }
        }
        dataTask.resume()
    }

    private func handleNetworkError(_ error: Error, _ completion: @escaping (Result<Data, NetworkError>) -> Void) {
        if let error = error as NSError?, error.code == NSURLErrorNotConnectedToInternet {
            completion(.failure(.noInternetConnection))
        } else {
            completion(.failure(.requestFailed))
        }
    }

    private func handleHTTPResponse(_ response: URLResponse?, _ data: Data?, _ completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(.noServerResponse))
            return
        }

        switch httpResponse.statusCode {
        case 200:
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(.noDataInServerResponse))
            }
        case 403:
            completion(.failure(.forbidden403))
        default:
            completion(.failure(.badResponse(statusCode: httpResponse.statusCode)))
        }
    }

    private func parseNews(from data: Data, completion: @escaping (Result<News, NetworkError>) -> Void) {
        let decoder = JSONDecoder()
        do {
            let news = try decoder.decode(News.self, from: data)
            completion(.success(news))
        } catch {
            completion(.failure(NetworkError.decodingFailed))
        }
    }
}
