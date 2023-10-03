//
//  Request.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 28.09.2023.
//

struct SearchSettings {
    private enum Constants {
        static let defaultArticleLanguage = "any"
        static let defaultArticlePublicationCountry = "any"
        static let defaultSortBy = "publishedAt"
        static let titleSortQueryParameter = "title"
        static let descriptionSortQueryParameter = "description"
    }

    var articleLanguage: String
    var publicationCountry: String
    var searchInTitlesIsOn: Bool
    var searchInDescriptionsIsOn: Bool
    var searchInContentsIsOn: Bool
    var sortedBy: String

    init(articleLanguage: String = Constants.defaultArticleLanguage,
         publicationCountry: String = Constants.defaultArticlePublicationCountry,
         searchInTitlesIsOn: Bool = true,
         searchInDescriptionsIsOn: Bool = true,
         searchInContentsIsOn: Bool = false,
         sortedBy: String = Constants.defaultSortBy) {
        self.articleLanguage = articleLanguage
        self.publicationCountry = publicationCountry
        self.searchInTitlesIsOn = searchInTitlesIsOn
        self.searchInDescriptionsIsOn = searchInDescriptionsIsOn
        self.searchInContentsIsOn = searchInContentsIsOn
        self.sortedBy = sortedBy
    }
}

struct Request {
    private enum Constants {
        static let keyword = "iOS"
    }

    let settings: SearchSettings
    let keyword: String

    init(settings: SearchSettings = SearchSettings(), keyword: String = Constants.keyword) {
        self.settings = settings
        self.keyword = keyword
    }
}
