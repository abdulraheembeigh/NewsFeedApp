//
//  CacheAsyncImage.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 17/06/2025.
//

import SwiftUI

// MARK: - Cache Async Image View
struct CacheAsyncImage<Content>: View where Content: View {
    private let url: URL
    private let scale: CGFloat
    private let content: (AsyncImagePhase) -> Content
    
    @State private var loader = AsyncImageLoader()
    
    init(
        url: URL,
        scale: CGFloat = 1.0,
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.content = content
    }
    
    var body: some View {
        content(currentPhase)
            .onAppear {
                loader.loadImage(from: url)
            }
            .onDisappear {
                loader.cancel()
            }
    }
    
    private var currentPhase: AsyncImagePhase {
        if let image = loader.image {
            return .success(Image(uiImage: image).resizable())
        } else if loader.isLoading {
            return .empty
        } else if let error = loader.error {
            return .failure(error)
        } else {
            return .empty
        }
    }
}

// MARK: - Convenience Initializers
extension CacheAsyncImage where Content == Image {
    init(url: URL, scale: CGFloat = 1.0) {
        self.init(url: url, scale: scale) { phase in
            if case .success(let image) = phase {
                return image
            } else {
                return Image(systemName: "photo")
            }
        }
    }
}
