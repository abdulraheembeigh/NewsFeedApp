//
//  LoadImage.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 18/06/2025.
//
import SwiftUI

struct LoadImage: View {
    var article: Article
    
    var body: some View {
        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
            CacheAsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 260)
                        .cornerRadius(10)
                        .clipped()
                case .failure(let error):
                    Text("Error: \(error.localizedDescription)")
                @unknown default:
                    Image(.defaultImg).resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame( height: 260)
                        .cornerRadius(20)
                        .clipped()
                }
            }
        } else {
            Image(.defaultImg).resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 340, height: 260)
                .clipped()
        }
    }
}
#Preview {
    LoadImage(article: PreviewData.loadNewsFeed()[0])
}
