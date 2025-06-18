//
//  MockEndpoint.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 18/06/2025.
//
@testable import NewsFeedApp

struct MockEndpoint: Endpoint {
    var baseURLString: String {
        return "https://example.com"
    }
    
    var path: String {
        return "/api/users"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer access_token"
        ]
    }
    
    var parameters: [String: String] {
        return [
            "date": "2024-08-21"
        ]
    }
}
