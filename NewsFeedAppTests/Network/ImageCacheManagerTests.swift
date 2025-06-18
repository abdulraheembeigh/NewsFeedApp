//
//  ImageCacheManagerTests.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 18/06/2025.
//


import Testing
import UIKit
@testable import NewsFeedApp

@Suite("ImageCacheManager Tests")
@MainActor
struct ImageCacheManagerTests {
    
    private let url = URL(string: "https://example.com/test.jpg")!
    private let image = UIImage(systemName: "star.fill")!
    
    /// Creates a new, isolated instance of ImageCacheManager with a unique URLCache.
    private func makeTestCacheManager() -> ImageCacheManager {
        let uniqueDiskPath = UUID().uuidString // Ensures cache isolation per test
        let urlCache = URLCache(
            memoryCapacity: 50 * 1024 * 1024,
            diskCapacity: 100 * 1024 * 1024,
            diskPath: uniqueDiskPath
        )
        return ImageCacheManager(customCache: urlCache)
    }
    
    @Test("Memory cache storage and retrieval")
    func testMemoryCacheStorageAndRetrieval() async {
        // Given
        let data = image.pngData()!
        let cache = makeTestCacheManager()
        
        // When
        cache.clearCache()
        cache.cacheImage(data: data, for: url)
        
        // Then
        let cachedImage = cache.cachedImage(for: url)
        #expect(cachedImage != nil, "Image should be retrievable from cache")
    }
    
    @Test("Cache clearing functionality")
    func testCacheClearing() async {
        // Given
        let data = image.pngData()!
        let cache = makeTestCacheManager()
        
        cache.cacheImage(data: data, for: url)
        
        // Confirm image is cached
        let preClearImage = cache.cachedImage(for: url)
        #expect(preClearImage != nil, "Image should be in cache before clearing")
        
        // When
        cache.clearCache()
        
        // time for disk I/O to flush
        try? await Task.sleep(nanoseconds: 200_000_000) // 0.2 sec
        
        // Then
        let postClearImage = cache.cachedImage(for: url)
        #expect(postClearImage == nil, "Image should be removed from cache after clearing")
    }
    
    @Test("Invalid image data is not cached")
    func testInvalidImageDataDoesNotCache() async {
        // Given
        let invalidData = Data("not-an-image".utf8)
        let cache = ImageCacheManager.shared
        
        // When
        cache.clearCache()
        cache.cacheImage(data: invalidData, for: url)
        
        // Then
        let image = cache.cachedImage(for: url)
        #expect(image == nil, "Invalid image data should not be cached")
    }
}
