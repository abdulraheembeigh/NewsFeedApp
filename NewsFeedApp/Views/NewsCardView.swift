//
//  NewsCardView.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 17/06/2025.
//
import SwiftUI

struct NewsCardView: View {
    var article: Article
    
    var body: some View {
        NavigationLink(destination: ArticleDetailView(article: article)) {
            ZStack(alignment: .bottom) {
                LoadImage(article: article)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .frame(width: 300.0)
                    
                    if let desc = article.description {
                        Text(desc)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                            .frame(width: 300.0)
                    }
                }
                .padding(10)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 10)
                .padding(.horizontal, 8)
            }
            .frame(width: 340, height: 260)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        .linearGradient(
                            colors: [.white.opacity(0.3), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
        }
    }
}
#Preview {
    NewsCardView(article: PreviewData.loadNewsFeed()[0])
}
