//
//  AsyncImageLoader.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 17/06/2025.
//

import Foundation
import UIKit


// MARK: - Custom Async Image Loader
@MainActor
@Observable
final class AsyncImageLoader {
    var image: UIImage?
    var isLoading = false
    var error: Error?
    
    private var loadTask: Task<Void, Never>?
    private let cacheManager = ImageCacheManager.shared
    private let taskStorage = TaskStorage()
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func loadImage(from url: URL) {
        loadTask?.cancel()
        taskStorage.cancel()
        
        if let cachedImage = cacheManager.cachedImage(for: url) {
            self.image = cachedImage
            self.isLoading = false
            self.error = nil
            return
        }
        
        self.isLoading = true
        self.error = nil
        
        let task = Task { @MainActor in
            do {
                let (data, response) = try await session.data(from: url)
                
                try Task.checkCancellation()
                
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                guard let loadedImage = UIImage(data: data) else {
                    throw URLError(.cannotDecodeContentData)
                }
                
                cacheManager.cacheImage(data: data, for: url)
                
                self.image = loadedImage
                self.isLoading = false
            } catch is CancellationError {
                self.isLoading = false
                return
            } catch {
                self.error = error
                self.isLoading = false
            }
        }
        
        loadTask = task
        taskStorage.store(task)
    }
    
    func cancel() {
        loadTask?.cancel()
        loadTask = nil
        taskStorage.cancel()
    }
}
