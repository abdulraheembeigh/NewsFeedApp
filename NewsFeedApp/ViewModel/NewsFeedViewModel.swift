//
//  NewsFeedViewModel.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 17/06/2025.
//

import Foundation
// MARK: - Category Enum
enum NewsCategory: String, CaseIterable, Identifiable {
    case business, entertainment, general, health, science, sports, technology
    var id: String { rawValue }
    var displayName: String { rawValue.capitalized }
}
@Observable
@MainActor
class NewsFeedViewModel {
    var articles: [Article] = []
    var isLoading = false
    var errorMessage: String?
    var selectedCategory: NewsCategory = .general {
        didSet {
            Task { await fetchArticles() }
        }
    }
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    
    func fetchArticles() async {
        let newsEndPoint = NewsEndPoint(parameters: ["category" : selectedCategory.rawValue])
        isLoading = true
        errorMessage = nil
        do {
            let data : ArticleResponse = try await networkService.request(newsEndPoint)
            self.articles = data.articles
        } catch {
            self.errorMessage = "Failed to load articles: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
