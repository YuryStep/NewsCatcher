//
//  APIRequestBuilder.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 05.09.2023.
//

import Foundation

protocol AppRequestBuilder {
    func makeSearchURL(for: Request) -> URL?
}

final class APIRequestBuilder: AppRequestBuilder {
    private enum Constants {
        static let apiKey = "05119a9d9eec92db2c653876cf3e015c"
        static let searchEndpoint = "https://gnews.io/api/v4/search"

        static let searchQueryParameter = "q"
        static let apiKeyQueryParameter = "apikey"
        static let languageQueryParameter = "lang"
        static let countryQueryParameter = "country"
        static let searchPlacesQueryParameter = "in"
        static let sortQueryParameter = "sortby"
        static let titleSortQueryParameter = "title"
        static let descriptionSortQueryParameter = "description"
        static let contentSortQueryParameter = "content"
        static let sortSeparatorQueryParameter = ","
    }

    func makeSearchURL(for request: Request) -> URL? {
        let queryItems = buildQueryItems(for: request)
        var components = URLComponents(string: Constants.searchEndpoint)!
        components.queryItems = queryItems
        return components.url
    }

    private func buildQueryItems(for request: Request) -> [URLQueryItem] {
        var queryItems = [
            URLQueryItem(name: Constants.searchQueryParameter, value: request.keyword.formattedSearchQuery()),
            URLQueryItem(name: Constants.apiKeyQueryParameter, value: Constants.apiKey)
        ]

        let lang = request.settings.articleLanguage.code
        queryItems.append(URLQueryItem(name: Constants.languageQueryParameter, value: lang))

        let country = request.settings.publicationCountry.code
        queryItems.append(URLQueryItem(name: Constants.countryQueryParameter, value: country))

        let searchPlaces = getSearchPlacesQueryStringFrom(request.settings)
        queryItems.append(URLQueryItem(name: Constants.searchPlacesQueryParameter, value: searchPlaces))

        let sortBy = request.settings.sortedBy
        queryItems.append(URLQueryItem(name: Constants.sortQueryParameter, value: sortBy))

        return queryItems
    }

    private func getSearchPlacesQueryStringFrom(_ requestSettings: SearchSettings) -> String {
        var searchPlaces: [String] = []

        if requestSettings.searchInTitlesIsOn {
            searchPlaces.append(Constants.titleSortQueryParameter)
        }

        if requestSettings.searchInDescriptionsIsOn {
            searchPlaces.append(Constants.descriptionSortQueryParameter)
        }

        if requestSettings.searchInContentsIsOn {
            searchPlaces.append(Constants.contentSortQueryParameter)
        }
        return searchPlaces.joined(separator: Constants.sortSeparatorQueryParameter)
    }
}
