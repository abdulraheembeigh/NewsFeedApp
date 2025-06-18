

import Foundation
import UIKit

@MainActor
@Observable
final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let urlCache: URLCache
    private let memoryCache = NSCache<NSString, UIImage>()
    init(customCache: URLCache? = nil) {
        self.urlCache = customCache ?? URLCache(
            memoryCapacity: 100 * 1024 * 1024,
            diskCapacity: 200 * 1024 * 1024,
            diskPath: "image_cache"
        )
        URLCache.shared = self.urlCache
    }
    
    private init() {
        // Create custom URLCache with larger capacity
        urlCache = URLCache(
            memoryCapacity: 100 * 1024 * 1024,  // 100MB (increased)
            diskCapacity: 200 * 1024 * 1024,    // 200MB (increased)
            diskPath: "image_cache"              // Custom disk path
        )
        
        // Configure in-memory cache
        memoryCache.countLimit = 100  // Max 100 images in memory
        memoryCache.totalCostLimit = 50 * 1024 * 1024  // 50MB memory limit
        
        // Set as shared cache
        URLCache.shared = urlCache
    }
    
    func cachedImage(for url: URL) -> UIImage? {
        
        if let mem = memoryCache.object(forKey: url.absoluteString as NSString) {
            return mem
        }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        if let disk = urlCache.cachedResponse(for: request),
           let image = UIImage(data: disk.data) {
            memoryCache.setObject(image, forKey: url.absoluteString as NSString, cost: disk.data.count)
            return image
        }
        return nil
    }
    
    func cacheImage(data: Data, for url: URL) {
        let urlString = url.absoluteString
        
        // Create image and store in memory cache
        if let image = UIImage(data: data) {
            memoryCache.setObject(image, forKey: urlString as NSString, cost: data.count)
        }
        
        // Store in URL cache with proper headers
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        // Create response with cache-friendly headers
        let headers = [
            "Content-Type": "image/jpeg",
            "Cache-Control": "max-age=31536000",  // 1 year
            "Last-Modified": DateFormatter().string(from: Date())
        ]
        
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: "HTTP/1.1",
            headerFields: headers
        ) ?? URLResponse(
            url: url,
            mimeType: "image/jpeg",
            expectedContentLength: data.count,
            textEncodingName: nil
        )
        
        let cachedResponse = CachedURLResponse(
            response: response,
            data: data,
            userInfo: nil,
            storagePolicy: .allowed  // Allow both memory and disk storage
        )
        urlCache.storeCachedResponse(cachedResponse, for: request)
    }
    
    func clearCache() {
        memoryCache.removeAllObjects()
        urlCache.removeAllCachedResponses()
    }
}
