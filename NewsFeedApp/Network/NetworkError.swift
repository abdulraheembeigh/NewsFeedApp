//
//  NetworkError.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 16/06/2025.
//

import Foundation
// MARK: - NetworkError enum
enum NetworkError: Error {
    case invalidURL
    case httpError(statusCode: Int)
    case decodingError
    case unknownError
}
