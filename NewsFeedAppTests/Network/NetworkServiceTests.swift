//
//  NetworkServiceTests.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 18/06/2025.
//
import Testing
import Foundation
@testable import NewsFeedApp

@Suite("NetworkServiceTests", .serialized)
struct NetworkServiceTests {
    
    static func makeService() -> NetworkService {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        return NetworkService(urlSession: session)
    }
    
    @Test("Invalid URL response throws decodingError")
    static func testInvalidURLThrowsDecodingError() async throws {
        defer { MockURLProtocol.requestHandler = nil }
        // Given
        let service = makeService()
        
        //When
        MockURLProtocol.requestHandler = { _ in (nil, nil) }
        
        //Then
        do {
            let _: Article = try await service.request(MockEndpoint())
            Issue.record("Expected unknownError to be thrown")
        } catch NetworkError.invalidURL {
            // ✅ Expected
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test("HTTP error throws httpError")
    static func testHTTPErrorThrowsHTTPError() async throws {
        defer { MockURLProtocol.requestHandler = nil }
        // Given
        let service = makeService()
        
        //When
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        
        //Then
        do {
            let _: Article = try await service.request(MockEndpoint())
            Issue.record("Expected httpError to be thrown")
        } catch NetworkError.httpError(let code) {
            #expect(code == 404)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test("Decoding error throws decodingError")
    static func testDecodingErrorThrowsDecodingError() async throws {
        defer { MockURLProtocol.requestHandler = nil }
        // Given
        let service = makeService()
        
        //When
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = "invalid json".data(using: .utf8)!
            return (response, data)
        }
        
        //Then
        do {
            let _: Article = try await service.request(MockEndpoint())
            Issue.record("Expected decodingError to be thrown")
        } catch NetworkError.decodingError {
            // ✅ Expected
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
    
    @Test("Successful response returns decoded data")
    static func testSuccessfulResponseReturnsDecodedData() async throws {
        defer { MockURLProtocol.requestHandler = nil }
        // Given
        let service = makeService()
        let expectedModel = Article(title: "TestTitle", description: "TestArticleDescription", url: "Testurl", urlToImage: "TesturlToImage", publishedAt: "TestPublishedAt", content: "TestContent")
        
        //When
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = try! JSONEncoder().encode(expectedModel)
            return (response, data)
        }
        
        //Then
        let result: Article = try await service.request(MockEndpoint())
        
        #expect(result.urlToImage == expectedModel.urlToImage)
        #expect(result.description == expectedModel.description)
        #expect(result.title == expectedModel.title)
        #expect(result.url == expectedModel.url)
        #expect(result.publishedAt == expectedModel.publishedAt)
        #expect(result.content == expectedModel.content)
    }
}
