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
    case noArticlesFound

    case badRequest400
    case unauthorized401
    case forbidden403
    case tooManyRequests429
    case internalServerError500
    case serviceUnavailable503
    case undefinedServerError

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noInternetConnection:
            return "No Internet Connection"
        case .requestFailed:
            return "Request Failed"
        case .noServerResponse:
            return "There is no response from the server"
        case .noDataInServerResponse:
            return "There is no data in the server response"
        case .decodingFailed:
            return "Decoding Failed"
        case .noArticlesFound:
            return "No articles found. Try to change searching phrase"
        case .badRequest400:
            return "Your request is invalid. StatusCode: 400"
        case .unauthorized401:
            return "Your API key is wrong. StatusCode: 401"
        case .forbidden403:
            return "You have reached your daily quota, the next reset is at 00:00 UTC. StatusCode: 403"
        case .tooManyRequests429:
            return "You have made more requests per second than you are allowed. StatusCode: 429"
        case .internalServerError500:
            return "We had a problem with our server. Try again later. StatusCode: 500"
        case .serviceUnavailable503:
            return "We're temporarily offline for maintenance. Please try again later StatusCode: 503"
        case .undefinedServerError:
            return "Undefined Server Error"
        }
    }

    static func getInvalidServerResponseError(httpResponse: HTTPURLResponse) -> Self {
        switch httpResponse.statusCode {
        case 400: return badRequest400
        case 401: return unauthorized401
        case 403: return forbidden403
        case 429: return tooManyRequests429
        case 500: return internalServerError500
        case 503: return serviceUnavailable503
        default: return undefinedServerError
        }
    }
}
