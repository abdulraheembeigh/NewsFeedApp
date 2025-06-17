//
//  EndPoint.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 16/06/2025.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}
// MARK: - Endpoint protocol
protocol Endpoint {
    var baseURLString: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: String] { get }
}

extension Endpoint {
    func getURLRequest() throws -> URLRequest {
        guard let baseURL = URL(string: baseURLString) else {
            throw NetworkError.invalidURL
        }
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        print(url.absoluteString)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = 15
        return request
    }
}
