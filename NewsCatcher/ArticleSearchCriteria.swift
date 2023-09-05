//
//  ArticleSearchCriteria.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 05.09.2023.
//

protocol ArticleSearchCriteria {
    var articleLanguage: String { get }
    var articlePublicationCountry: String { get }
    var searchPlaces: String { get }
    var sortedBy: String { get }
}
