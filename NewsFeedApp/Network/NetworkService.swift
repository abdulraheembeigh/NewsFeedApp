//
//  NetworkService.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 16/06/2025.
//

import Foundation
// MARK: - NetworkService
protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

class NetworkService: NetworkServiceProtocol {
    private let urlSession: URLSession
    
    //default initialition of 150 MB
    init(urlSession: URLSession = URLSession.shared, cacheCapacity: Int = 150 * 1024 * 1024) {
        let cache = URLCache.shared
        cache.memoryCapacity = cacheCapacity
        cache.diskCapacity = cacheCapacity
        
        let configuration = urlSession.configuration//URLSessionConfiguration.default
        configuration.urlCache = cache
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        self.urlSession = urlSession
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        var request = try endpoint.getURLRequest()
        request.cachePolicy = .returnCacheDataElseLoad
        guard let (data, response) = try? await urlSession.data(for: request) else {
            throw NetworkError.invalidURL 
        }
        if let httpResponse = response as? HTTPURLResponse, !(200...299 ~= httpResponse.statusCode) {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch{
            throw NetworkError.decodingError
        }
    }
}
