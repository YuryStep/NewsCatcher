//
//  RequestSettings.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 28.09.2023.
//

protocol SearchCriteria {
    var articleLanguage: String? { get }
    var publicationCountry: String? { get }
    var searchInTitlesIsOn: Bool { get }
    var searchInDescriptionsIsOn: Bool { get }
    var searchInContentsIsOn: Bool { get }
    var sortedBy: String? { get }
}

struct RequestSettings: SearchCriteria {
    let articleLanguage: String?
    let publicationCountry: String?
    let searchInTitlesIsOn: Bool
    let searchInDescriptionsIsOn: Bool
    let searchInContentsIsOn: Bool
    let sortedBy: String?

    init(articleLanguage: String? = nil,
         publicationCountry: String? = nil,
         searchInTitlesIsOn: Bool = true,
         searchInDescriptionsIsOn: Bool = true,
         searchInContentsIsOn: Bool = false,
         sortedBy: String? = nil)
    {
        self.articleLanguage = articleLanguage
        self.publicationCountry = publicationCountry
        self.searchInTitlesIsOn = searchInTitlesIsOn
        self.searchInDescriptionsIsOn = searchInDescriptionsIsOn
        self.searchInContentsIsOn = searchInContentsIsOn
        self.sortedBy = sortedBy
    }
}
