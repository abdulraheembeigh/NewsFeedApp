//
//  URLSessionProtocol.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 18/06/2025.
//


import Foundation
import UIKit

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
