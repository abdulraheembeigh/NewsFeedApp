//
//  MockNetworkService.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 18/06/2025.
//
import Foundation
@testable import NewsFeedApp 

// Mock URLSession to simulate network responses

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse?, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("No handler set for MockURLProtocol")
        }
        
        do {
            let (response, data) = try handler(request)
            if let response = response, let data = data {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
            } else {
                client?.urlProtocol(self, didFailWithError: NSError(domain: "InvalidResponse", code: 0, userInfo: nil))
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // No action needed
    }
}

