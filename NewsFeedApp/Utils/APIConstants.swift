//
//  APIConstants.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 16/06/2025.
//

import Foundation
enum APIConstants {
    static let baseURL = "https://newsapi.org"
    static var  apiKey : String {
        guard let key = Bundle.main.infoDictionary?["NEWS_API_KEY"] as? String else {
            preconditionFailure("Please check your xcconfig file and add NEWS_API_KEY")
        }
        return key//"8815d577462a4195a64f6f50af3ada08"
    }
    static let newsPath = "/v2/top-headlines"
}
