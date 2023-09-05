//
//  APIRequestBuilder.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 05.09.2023.
//

import Foundation

protocol AppRequestBuilder {
    func getURLRequestString(usingSearchPhrase: String?, searchCriterias: ArticleSearchCriteria?) -> String
    func getDefaultAPISting () -> String
}

class APIRequestBuilder: AppRequestBuilder {
    private struct Constants {
        static let defaultAPISting = "https://gnews.io/api/v4/search?q=example&lang=en&country=us&max=10&apikey=05119a9d9eec92db2c653876cf3e015c"
        static let searchEndpoint = "https://gnews.io/api/v4/search?q="
        static let apiKey = "05119a9d9eec92db2c653876cf3e015c"
        // Default query parameters
        static let defaultArticleLanguage = "en"
        static let defaultArticlePublicationCountry = "any"
        static let defaultSearchPlaces = "title,description"
        static let defaultSortBy = "publishedAt"
    }
    
    func getURLRequestString(usingSearchPhrase searchPhrase: String?, searchCriterias: ArticleSearchCriteria?) -> String {
        guard let searchPhrase = searchPhrase else { return Constants.defaultAPISting }
        let query = turnIntoAPIQuery(SearchFrase: searchPhrase)
        let lang = searchCriterias?.articleLanguage ?? Constants.defaultArticleLanguage
        let country = searchCriterias?.articlePublicationCountry ?? Constants.defaultArticlePublicationCountry
        let searchPlaces = searchCriterias?.searchPlaces ?? Constants.defaultSearchPlaces
        let sortBy = searchCriterias?.sortedBy ?? Constants.defaultSortBy
        
        let urlRequestString = Constants.searchEndpoint + query + "&lang=\(lang)" + "&country=\(country)" + "&in=\(searchPlaces)" + "&sortby=\(sortBy)" + "&apikey=\(Constants.apiKey)"
        
        return urlRequestString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlRequestString
    }
    
    func getDefaultAPISting () -> String {
        return Constants.defaultAPISting
    }
    
    private func turnIntoAPIQuery(SearchFrase frase: String) -> String {
        return frase.removeExtraSpaces()
    }

}
