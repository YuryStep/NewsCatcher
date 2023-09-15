//
//  NCArticle.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 15.09.2023.
//

import Foundation

protocol AppArticle: Codable {
    var title: String { get }
    var description: String { get }
    var content: String { get }
    var url: String { get }
    var imageURL: String { get }
    var publishedAt: String { get }
    var sourceName: String { get }
}

// MARK: Model Entity

struct NCArticle: AppArticle {
    var title: String
    var description: String
    var content: String
    var url: String
    var imageURL: String
    var publishedAt: String
    var sourceName: String
}
