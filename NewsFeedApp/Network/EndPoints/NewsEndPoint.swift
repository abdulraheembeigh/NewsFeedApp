//
//  NewsEndPoint.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 16/06/2025.
//

import Foundation
// MARK: - NewsEndPoint endpoint
struct NewsEndPoint: Endpoint {
    let baseURLString: String
    let path: String
    let method: HTTPMethod = .get
    let headers: [String: String]? = nil
    var parameters: [String: String]
    
    init(parameters: [String:String] = [:]) {
        self.baseURLString = APIConstants.baseURL
        self.path = APIConstants.newsPath
        self.parameters = parameters
        self.parameters["country"] = "us" 
        self.parameters["apiKey"] = APIConstants.apiKey
    }
}
