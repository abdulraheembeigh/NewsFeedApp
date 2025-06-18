//
//  NewsCategoryTests.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 18/06/2025.
//
import Testing
@testable import NewsFeedApp


@Suite("NewsCategory Tests")
struct NewsCategoryTests {
    
    @Test("All news categories exist")
    func allCases() {
        // Given & When
        let categories = NewsCategory.allCases
        
        // Then
        #expect(categories.count == 7)
        #expect(categories.contains(.business))
        #expect(categories.contains(.entertainment))
        #expect(categories.contains(.general))
        #expect(categories.contains(.health))
        #expect(categories.contains(.science))
        #expect(categories.contains(.sports))
        #expect(categories.contains(.technology))
    }
    
    @Test("Category display names")
    func displayName() {
        // Given & When & Then
        #expect(NewsCategory.business.displayName == "Business")
        #expect(NewsCategory.entertainment.displayName == "Entertainment")
        #expect(NewsCategory.general.displayName == "General")
        #expect(NewsCategory.health.displayName == "Health")
        #expect(NewsCategory.science.displayName == "Science")
        #expect(NewsCategory.sports.displayName == "Sports")
        #expect(NewsCategory.technology.displayName == "Technology")
    }
    
    @Test("Category identifiable protocol")
    func identifiable() {
        // Given & When & Then
        #expect(NewsCategory.business.id == "business")
        #expect(NewsCategory.technology.id == "technology")
        #expect(NewsCategory.general.id == "general")
    }
}
