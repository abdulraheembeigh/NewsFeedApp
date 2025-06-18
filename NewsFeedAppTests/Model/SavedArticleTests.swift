//
//  SavedArticleTests.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 18/06/2025.
//
import Testing
@testable import NewsFeedApp


@Suite("SavedArticle Tests")
struct SavedArticleTests {
    
    @Test("SavedArticle initialization from Article")
    func savedArticleInitialization() {
        // Given
        let article = Article(
            title: "Test Title",
            description: "Test Description",
            url: "https://example.com",
            urlToImage: "https://example.com/image.jpg",
            publishedAt: "2024-01-01T00:00:00Z",
            content: "Test Content"
        )
        
        // When
        let savedArticle = SavedArticle(article: article)
        
        // Then
        #expect(savedArticle.title == "Test Title")
        #expect(savedArticle.articleDescription == "Test Description")
        #expect(savedArticle.url == "https://example.com")
        #expect(savedArticle.urlToImage == "https://example.com/image.jpg")
        #expect(savedArticle.publishedAt == "2024-01-01T00:00:00Z")
        #expect(savedArticle.content == "Test Content")
    }
    
    @Test("SavedArticle with nil values")
    func savedArticleWithNilValues() {
        // Given
        let article = Article(
            title: "Test Title",
            description: nil,
            url: "https://example.com",
            urlToImage: nil,
            publishedAt: "2024-01-01T00:00:00Z",
            content: nil
        )
        
        // When
        let savedArticle = SavedArticle(article: article)
        
        // Then
        #expect(savedArticle.title == "Test Title")
        #expect(savedArticle.articleDescription == nil)
        #expect(savedArticle.url == "https://example.com")
        #expect(savedArticle.urlToImage == nil)
        #expect(savedArticle.publishedAt == "2024-01-01T00:00:00Z")
        #expect(savedArticle.content == nil)
    }
}
