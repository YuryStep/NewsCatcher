//
//  RequestSettings.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 28.09.2023.
//

protocol SearchCriteria {
    var articleLanguage: String { get }
    var publicationCountry: String { get }
    var searchInTitlesIsOn: Bool { get }
    var searchInDescriptionsIsOn: Bool { get }
    var searchInContentsIsOn: Bool { get }
    var sortedBy: String { get }
}

struct RequestSettings: SearchCriteria {
    private enum Constants {
        static let defaultArticleLanguage = "any"
        static let defaultArticlePublicationCountry = "any"
        static let defaultSortBy = "publishedAt"
    }

    let articleLanguage: String
    let publicationCountry: String
    let searchInTitlesIsOn: Bool
    let searchInDescriptionsIsOn: Bool
    let searchInContentsIsOn: Bool
    let sortedBy: String
    init(articleLanguage: String = Constants.defaultArticleLanguage,
         publicationCountry: String = Constants.defaultArticlePublicationCountry,
         searchInTitlesIsOn: Bool = true,
         searchInDescriptionsIsOn: Bool = true,
         searchInContentsIsOn: Bool = false,
         sortedBy: String = Constants.defaultSortBy)
    {
        self.articleLanguage = articleLanguage
        self.publicationCountry = publicationCountry
        self.searchInTitlesIsOn = searchInTitlesIsOn
        self.searchInDescriptionsIsOn = searchInDescriptionsIsOn
        self.searchInContentsIsOn = searchInContentsIsOn
        self.sortedBy = sortedBy
    }
}
