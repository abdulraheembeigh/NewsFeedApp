//
//  NewsFeedViewModelTests.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 18/06/2025.
//
import Testing
@testable import NewsFeedApp

@Suite("NewsFeedViewModel Tests")
@MainActor
struct NewsFeedViewModelTests {
    
    @Test("ViewModel initial state")
    func initialState() {
        // Given & When
        let mockNetworkService = MockNetworkService()
        let viewModel = NewsFeedViewModel(networkService: mockNetworkService)
        
        // Then
        #expect(viewModel.articles.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.selectedCategory == .general)
    }
    
    @Test("Successful article fetching")
    func successfulFetchArticles() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let viewModel = NewsFeedViewModel(networkService: mockNetworkService)
        
        let mockArticles = [
            Article(title: "Article 1", description: nil, url: "https://test1.com", 
                    urlToImage: nil, publishedAt: "2024-01-01", content: nil),
            Article(title: "Article 2", description: nil, url: "https://test2.com", 
                    urlToImage: nil, publishedAt: "2024-01-02", content: nil)
        ]
        let mockResponse = ArticleResponse(articles: mockArticles)
        mockNetworkService.mockResponse = mockResponse
        
        // When
        await viewModel.fetchArticles()
        
        // Then
        #expect(viewModel.articles.count == 2)
        #expect(viewModel.articles[0].title == "Article 1")
        #expect(viewModel.articles[1].title == "Article 2")
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test("Failed article fetching")
    func failedFetchArticles() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let viewModel = NewsFeedViewModel(networkService: mockNetworkService)
        
        mockNetworkService.shouldThrowError = true
        mockNetworkService.errorToThrow = .httpError(statusCode: 500)
        
        // When
        await viewModel.fetchArticles()
        
        // Then
        #expect(viewModel.articles.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.errorMessage?.contains("Failed to load articles") == true)
    }
    
    @Test("Loading state during fetch")
    func loadingState() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let viewModel = NewsFeedViewModel(networkService: mockNetworkService)
        
        mockNetworkService.shouldThrowError = true
        mockNetworkService.errorToThrow = .decodingError
        
        // When
        let fetchTask = Task {
            await viewModel.fetchArticles()
        }
        
        // Check loading state briefly
        #expect(viewModel.isLoading == false)
        
        await fetchTask.value
        
        // Then
        #expect(viewModel.isLoading == false)
    }
    
    @Test("Selected category change")
    func selectedCategoryChange() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let viewModel = NewsFeedViewModel(networkService: mockNetworkService)
        
        let mockResponse = ArticleResponse(articles: [])
        mockNetworkService.mockResponse = mockResponse
        
        // When
        viewModel.selectedCategory = .sports
        
        // Give some time for the async task to complete
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
        
        // Then
        #expect(viewModel.selectedCategory == .sports)
    }
    
    @Test("Error message clearing on successful fetch")
    func errorMessageClearingOnSuccess() async {
        // Given
        let mockNetworkService = MockNetworkService()
        let viewModel = NewsFeedViewModel(networkService: mockNetworkService)
        
        // First set an error
        viewModel.errorMessage = "Previous error"
        
        // Then setup successful response
        let mockResponse = ArticleResponse(articles: [])
        mockNetworkService.mockResponse = mockResponse
        
        // When
        await viewModel.fetchArticles()
        
        // Then
        #expect(viewModel.errorMessage == nil)
    }
}
