//
//  APIRequestBuilder.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 05.09.2023.
//

import Foundation

protocol AppRequestBuilder {
    func getURLRequestString(for keyPhrase: String?, searchCriteria: SearchCriteria) -> String
}

final class APIRequestBuilder: AppRequestBuilder {
    private enum Constants {
        static let apiKey = "05119a9d9eec92db2c653876cf3e015c"
        static let searchEndpoint = "https://gnews.io/api/v4/search"
        static let defaultSearchPlaces = "title,description"
        static let defaultKeyPhrase = "iOS"

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

    func getURLRequestString(for keyPhrase: String?, searchCriteria: SearchCriteria) -> String {
        let keyPhrase = keyPhrase ?? Constants.defaultKeyPhrase
        let queryItems = buildQueryItems(keyPhrase: keyPhrase, searchCriteria: searchCriteria)
        var components = URLComponents(string: Constants.searchEndpoint)!
        components.queryItems = queryItems

        if let url = components.url {
            print(url.absoluteString)
            return url.absoluteString
        } else {
            return ""
        }
    }

    private func buildQueryItems(keyPhrase: String, searchCriteria: SearchCriteria) -> [URLQueryItem] {
        var queryItems = [
            URLQueryItem(name: Constants.searchQueryParameter, value: keyPhrase),
            URLQueryItem(name: Constants.apiKeyQueryParameter, value: Constants.apiKey)
        ]

        let lang = searchCriteria.articleLanguage
        queryItems.append(URLQueryItem(name: Constants.languageQueryParameter, value: lang))

        let country = searchCriteria.publicationCountry
        queryItems.append(URLQueryItem(name: Constants.countryQueryParameter, value: country))

        let searchPlaces = getSearchPlacesQueryStringFrom(searchCriteria)
        queryItems.append(URLQueryItem(name: Constants.searchPlacesQueryParameter, value: searchPlaces))

        let sortBy = searchCriteria.sortedBy
        queryItems.append(URLQueryItem(name: Constants.sortQueryParameter, value: sortBy))

        return queryItems
    }

    private func getSearchPlacesQueryStringFrom(_ searchCriteria: SearchCriteria) -> String {
        var searchPlaces: [String] = []

        if searchCriteria.searchInTitlesIsOn {
            searchPlaces.append(Constants.titleSortQueryParameter)
        }

        if searchCriteria.searchInDescriptionsIsOn {
            searchPlaces.append(Constants.descriptionSortQueryParameter)
        }

        if searchCriteria.searchInContentsIsOn {
            searchPlaces.append(Constants.contentSortQueryParameter)
        }

        return searchPlaces.isEmpty ?
            Constants.defaultSearchPlaces :
            searchPlaces.joined(separator: Constants.sortSeparatorQueryParameter)
    }
}
