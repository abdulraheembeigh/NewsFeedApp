//
//  ArticleTests.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 18/06/2025.
//
import Testing
import Foundation
@testable import NewsFeedApp

@Suite("Article Tests")
struct ArticleTests {
    
    @Test("Article initialization")
    func articleInitialization() {
        // Given
        let article = Article(
            title: "Test Title",
            description: "Test Description",
            url: "https://example.com",
            urlToImage: "https://example.com/image.jpg",
            publishedAt: "2024-01-01T00:00:00Z",
            content: "Test Content"
        )
        
        // Then
        #expect(article.title == "Test Title")
        #expect(article.description == "Test Description")
        #expect(article.url == "https://example.com")
        #expect(article.urlToImage == "https://example.com/image.jpg")
        #expect(article.publishedAt == "2024-01-01T00:00:00Z")
        #expect(article.content == "Test Content")
        #expect(article.id != nil)
    }
    
    @Test("Article equality")
    func articleEquality() {
        // Given
        let article1 = Article(
            title: "Test Title",
            description: "Test Description",
            url: "https://example.com",
            urlToImage: nil,
            publishedAt: "2024-01-01T00:00:00Z",
            content: nil
        )
        
        let article2 = Article(
            title: "Test Title",
            description: "Test Description",
            url: "https://example.com",
            urlToImage: nil,
            publishedAt: "2024-01-01T00:00:00Z",
            content: nil
        )
        
        // Then
        #expect(article1 != article2) // Different IDs
        #expect(article1.title == article2.title)
        #expect(article1.url == article2.url)
    }
    
    @Test("Article codable decoding")
    func articleCodable() throws {
        // Given
        let jsonData = """
        {
            "title": "Test Title",
            "description": "Test Description",
            "url": "https://example.com",
            "urlToImage": "https://example.com/image.jpg",
            "publishedAt": "2024-01-01T00:00:00Z",
            "content": "Test Content"
        }
        """.data(using: .utf8)!
        
        // When
        let article = try JSONDecoder().decode(Article.self, from: jsonData)
        
        // Then
        #expect(article.title == "Test Title")
        #expect(article.description == "Test Description")
        #expect(article.url == "https://example.com")
        #expect(article.urlToImage == "https://example.com/image.jpg")
        #expect(article.publishedAt == "2024-01-01T00:00:00Z")
        #expect(article.content == "Test Content")
    }
    
    @Test("ArticleResponse codable decoding")
    func articleResponseCodable() throws {
        // Given
        let jsonData = """
        {
            "articles": [
                {
                    "title": "Article 1",
                    "description": null,
                    "url": "https://example.com/1",
                    "urlToImage": null,
                    "publishedAt": "2024-01-01T00:00:00Z",
                    "content": null
                },
                {
                    "title": "Article 2",
                    "description": "Description 2",
                    "url": "https://example.com/2",
                    "urlToImage": "https://example.com/2.jpg",
                    "publishedAt": "2024-01-02T00:00:00Z",
                    "content": "Content 2"
                }
            ]
        }
        """.data(using: .utf8)!
        
        // When
        let response = try JSONDecoder().decode(ArticleResponse.self, from: jsonData)
        
        // Then
        #expect(response.articles.count == 2)
        #expect(response.articles[0].title == "Article 1")
        #expect(response.articles[1].title == "Article 2")
        #expect(response.articles[0].description == nil)
        #expect(response.articles[1].description == "Description 2")
    }
}
