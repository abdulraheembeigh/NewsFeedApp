//
//  PreviewData.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 17/06/2025.
//

import Foundation

struct PreviewData{
    static func loadNewsFeed() -> [Article] {
        guard let url = Bundle.main.url(forResource: "newsfeed", withExtension: "json") else {
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(ArticleResponse.self, from: data)
            return response.articles
        } catch {
            print("Error loading JSON file: \(error)")
            return []
        }
    }
}
