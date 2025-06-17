//
//  Article.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 16/06/2025.
//

import Foundation
// MARK: - Article Model
struct Article: Identifiable, Codable, Equatable {
    let id = UUID()
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
    enum CodingKeys: CodingKey {
        case title
        case description
        case url
        case urlToImage
        case publishedAt
        case content
    }
}

struct ArticleResponse: Codable {
    let articles: [Article]
}
