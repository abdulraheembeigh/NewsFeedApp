//
//  NewsEndPointTests.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 18/06/2025.
//
import Testing
@testable import NewsFeedApp

@Suite("NewsEndPoint Tests")
struct NewsEndPointTests {
    
    @Test("NewsEndPoint default initialization")
    func newsEndPointInitialization() {
        // Given & When
        let endpoint = NewsEndPoint()
        
        // Then
        #expect(endpoint.baseURLString == APIConstants.baseURL)
        #expect(endpoint.path == APIConstants.newsPath)
        #expect(endpoint.method == .get)
        #expect(endpoint.headers == nil)
        #expect(endpoint.parameters["country"] == "us")
        #expect(endpoint.parameters["apiKey"] == APIConstants.apiKey)
    }
    
    @Test("NewsEndPoint with custom parameters")
    func newsEndPointWithCustomParameters() {
        // Given
        let customParams = ["category": "sports", "q": "football"]
        
        // When
        let endpoint = NewsEndPoint(parameters: customParams)
        
        // Then
        #expect(endpoint.parameters["category"] == "sports")
        #expect(endpoint.parameters["q"] == "football")
        #expect(endpoint.parameters["country"] == "us")
        #expect(endpoint.parameters["apiKey"] == APIConstants.apiKey)
    }
    
    @Test("NewsEndPoint URL request generation")
    func getURLRequest() throws {
        // Given
        let endpoint = NewsEndPoint(parameters: ["category": "business"])
        
        // When
        let request = try endpoint.getURLRequest()
        
        // Then
        #expect(request.url != nil)
        #expect(request.httpMethod == "GET")
        #expect(request.timeoutInterval == 15)
        
        let urlString = request.url?.absoluteString ?? ""
        #expect(urlString.contains("category=business"))
        #expect(urlString.contains("country=us"))
        #expect(urlString.contains("apiKey="))
    }
}
