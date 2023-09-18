//
//  APIRequestBuilder.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 05.09.2023.
//

protocol AppRequestBuilder {
    func getURLRequestString(for keyPhrase: String?, searchCriteria: ArticleSearchCriteria?) -> String
    func getDefaultAPISting() -> String
}

final class APIRequestBuilder: AppRequestBuilder {
    private enum Constants {
        static let defaultAPISting = "https://gnews.io/api/v4/search?q=example&lang=en&country=us&max=10&apikey=05119a9d9eec92db2c653876cf3e015c"
        static let searchEndpoint = "https://gnews.io/api/v4/search?q="
        static let apiKey = "05119a9d9eec92db2c653876cf3e015c"
        static let defaultArticleLanguage = "eng"
        static let defaultArticlePublicationCountry = "any"
        static let defaultSearchPlaces = "title,description"
        static let defaultSortBy = "publishedAt"
    }

    func getURLRequestString(for keyPhrase: String?, searchCriteria: ArticleSearchCriteria?) -> String {
        guard let keyPhrase = keyPhrase else { return Constants.defaultAPISting }
        let query = turnIntoAPIQuery(keyPhrase)
        let lang = searchCriteria?.articleLanguage ?? Constants.defaultArticleLanguage
        let country = searchCriteria?.publicationCountry ?? Constants.defaultArticlePublicationCountry
        let searchPlaces = searchCriteria?.searchPlaces ?? Constants.defaultSearchPlaces
        let sortBy = searchCriteria?.sortedBy ?? Constants.defaultSortBy
        // swiftlint:disable:next line_length
        let urlRequestString = Constants.searchEndpoint + query + "&lang=\(lang)" + "&country=\(country)" + "&in=\(searchPlaces)" + "&sortby=\(sortBy)" + "&apikey=\(Constants.apiKey)"
        return urlRequestString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlRequestString
    }

    func getDefaultAPISting() -> String {
        return Constants.defaultAPISting
    }

    private func turnIntoAPIQuery(_ keyPhrase: String) -> String {
        return keyPhrase.removeExtraSpaces()
    }
}
