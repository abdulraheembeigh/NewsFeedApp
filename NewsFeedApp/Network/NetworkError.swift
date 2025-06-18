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


// MARK: - User-Friendly Error Messages
extension NetworkError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid web address"
        case .httpError(let statusCode):
            return "Bad request with status code: \(statusCode)"
        case .decodingError:
            return "Unable to process image"
        case .unknownError:
            return "Something went wrong"
        }
    }
}
