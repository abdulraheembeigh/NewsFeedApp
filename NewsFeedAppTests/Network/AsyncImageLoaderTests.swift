//
//  AsyncImageLoaderTests.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 18/06/2025.
//
import Testing
import UIKit
@testable import NewsFeedApp 

// MARK: - AsyncImageLoader Tests
@Suite("AsyncImageLoader Tests")
@MainActor
struct AsyncImageLoaderTests {
    
    @Test("Successful image load from network")
    func testSuccessfulImageLoad() async {
        // Given
        let url = URL(string: "https://example.com/success.jpg")!
        let image = UIImage(systemName: "star")!
        let imageData = image.jpegData(compressionQuality: 1.0)!
        
        let mockSession = MockURLSession()
        mockSession.mockData = imageData
        mockSession.mockResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        let loader = AsyncImageLoader(session: mockSession)
        loader.loadImage(from: url)
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        // Then
        #expect(loader.image != nil, "Image should be loaded successfully")
        #expect(loader.error == nil, "No error should occur during successful load")
        #expect(loader.isLoading == false, "Loading state should be false after completion")
    }
    
    @Test("Network error handling")
    func testNetworkError() async {
        // Given
        let url = URL(string: "https://example.com/error.jpg")!
        
        let mockSession = MockURLSession()
        mockSession.mockError = URLError(.notConnectedToInternet)
        
        // When
        let loader = AsyncImageLoader(session: mockSession)
        loader.loadImage(from: url)
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        // Then
        #expect(loader.image == nil, "Image should not be loaded when network error occurs")
        #expect(loader.error != nil, "Error should be set when network fails")
        #expect(loader.isLoading == false, "Loading state should be false after error")
    }
    
    @Test("Invalid HTTP response handling")
    func testInvalidHTTPResponse() async {
        // Given
        let url = URL(string: "https://example.com/bad-response.jpg")!
        let imageData = Data([0xFF])
        
        let mockSession = MockURLSession()
        mockSession.mockData = imageData
        mockSession.mockResponse = HTTPURLResponse(
            url: url,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        let loader = AsyncImageLoader(session: mockSession)
        loader.loadImage(from: url)
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        // Then
        #expect(loader.image == nil, "Image should not be loaded with invalid HTTP response")
        #expect(loader.error != nil, "Error should be set for invalid HTTP response")
        #expect(loader.isLoading == false, "Loading state should be false after error")
    }
    
    @Test("Invalid image data handling")
    func testInvalidImageData() async {
        // Given
        let url = URL(string: "https://example.com/invalid-image.jpg")!
        let badData = Data([0x00, 0x01, 0x02])
        
        let mockSession = MockURLSession()
        mockSession.mockData = badData
        mockSession.mockResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        let loader = AsyncImageLoader(session: mockSession)
        loader.loadImage(from: url)
        
        // Wait for async operation to complete
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        // Then
        #expect(loader.image == nil, "Image should not be created from invalid data")
        #expect(loader.error != nil, "Error should be set for invalid image data")
        #expect(loader.isLoading == false, "Loading state should be false after error")
    }
    
    @Test("Loader cancellation behavior")
    func testLoaderCancelBehavior() async {
        // Given
        let url = URL(string: "https://example.com/cancel-test.jpg")!
        
        let mockSession = MockURLSession()
        mockSession.mockData = UIImage(systemName: "xmark")!.pngData()
        mockSession.mockResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let loader = AsyncImageLoader(session: mockSession)
        
        // When
        loader.loadImage(from: url)
        
        // Cancel before it completes
        loader.cancel()
        
        // Wait briefly to allow cancellation to take effect
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        // Then
        #expect(loader.image == nil, "Image should not be loaded after cancellation")
        #expect(loader.isLoading == false, "Loading state should be false after cancellation")
        #expect(loader.error == nil, "Error should not be set after clean cancellation")
    }
}

