//
//  SavedArticle.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 16/06/2025.
//

import Foundation
import SwiftData
// MARK: - SwiftData Model
@Model
class SavedArticle {
    var title: String
    var articleDescription: String?
    
    @Attribute(.unique) var url: String
    var urlToImage: String?
    var publishedAt: String
    var content: String?
    
    init(article: Article) {
        self.title = article.title
        self.articleDescription = article.description
        self.url = article.url
        self.urlToImage = article.urlToImage
        self.publishedAt = article.publishedAt
        self.content = article.content
    }
}
