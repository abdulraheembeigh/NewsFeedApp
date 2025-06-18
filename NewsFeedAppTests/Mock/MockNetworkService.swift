//
//  MockNetworkService.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 18/06/2025.
//
import Testing
@testable import NewsFeedApp

class MockNetworkService: NetworkServiceProtocol {
    var shouldThrowError = false
    var mockResponse: Any?
    var errorToThrow: NetworkError = .unknownError
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        if shouldThrowError {
            throw errorToThrow
        }
        
        if let response = mockResponse as? T {
            return response
        }
        
        throw NetworkError.decodingError
    }
}
