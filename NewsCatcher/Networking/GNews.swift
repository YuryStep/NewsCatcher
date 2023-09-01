//
//  GNewsContainer.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 01.09.2023.
//

import Foundation

// MARK: JSONContainer

// MARK: - News
struct GNews: Codable {
    let totalArticles: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let title: String
    let description: String
    let content: String
    let url: String
    let image: String
    let publishedAt: String
    let source: Source
}

// MARK: - Source
struct Source: Codable {
    let name: String
    let url: String
}
