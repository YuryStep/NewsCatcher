//
//  News.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

import Foundation

struct News: Codable {
    let totalArticles: Int
    let articles: [Article]
}

struct Article: Codable, Hashable, Identifiable {
    private enum CodingKeys: String, CodingKey {
        case title
        case description
        case content
        case urlString = "url"
        case imageStringURL = "image"
        case publishedAt
        case source
        case imageData
    }

    var id: String { urlString }
    let title: String
    let description: String
    let content: String
    let urlString: String
    let imageStringURL: String
    let publishedAt: String
    let source: Source
    var imageData: Data?

    static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Source: Codable {
    let name: String
    let url: String
}
