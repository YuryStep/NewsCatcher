//
//  News.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

struct News: Codable {
    let totalArticles: Int
    let articles: [Article]
}

struct Article: Codable {
    let title: String
    let description: String
    let content: String
    let urlString: String
    let imageStringURL: String
    let publishedAt: String
    let source: Source

    private enum CodingKeys: String, CodingKey {
        case title
        case description
        case content
        case urlString = "url"
        case imageStringURL = "image"
        case publishedAt
        case source
    }
}

struct Source: Codable {
    let name: String
    let url: String
}
