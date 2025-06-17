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
    
    // Store task reference for nonisolated access
    private let taskStorage = TaskStorage()
    
    func loadImage(from url: URL) {
        // Cancel any existing task
        loadTask?.cancel()
        taskStorage.cancel()
        
        if let cachedImage = cacheManager.cachedImage(for: url) {
            self.image = cachedImage
            self.isLoading = false
            self.error = nil
            return
        }
        
        // Load from network
        self.isLoading = true
        self.error = nil
        
        let task = Task { @MainActor in
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                // Check if task was cancelled
                try Task.checkCancellation()
                
                // Validate response
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                // Create image from data
                guard let loadedImage = UIImage(data: data) else {
                    throw URLError(.cannotDecodeContentData)
                }
                
                // Cache the original data (not the SwiftUI Image)
                cacheManager.cacheImage(data: data, for: url)
                
                // Update UI
                self.image = loadedImage
                self.isLoading = false
                
            } catch is CancellationError {
                // Task was cancelled, don't update state
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
