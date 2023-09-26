//
//  NetworkError.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 19.09.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noInternetConnection
    case requestFailed
    case noServerResponse
    case noDataInServerResponse
    case decodingFailed
    case forbidden403
    case badResponse(statusCode: Int)

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noInternetConnection:
            return "Unable to fetch news articles. Check your internet connection."
        case .requestFailed:
            return "Request Failed"
        case .noServerResponse:
            return "There is no response from the server"
        case .noDataInServerResponse:
            return "There is no data in the server response"
        case .decodingFailed:
            return "Decoding Failed"
        case .forbidden403:
            return "You have reached your daily quota. The next reset is at 00:00 UTC"
        case let .badResponse(statusCode: statusCode):
            return "There is a bad server response. StatusCode: \(statusCode)"
        }
    }
}
