//
//  ArticleDetailView.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 17/06/2025.
//

import SwiftUI
import SwiftData

struct ArticleDetailView: View {
    let article: Article
    @Environment(\.modelContext) private var context
    @Environment(\.openURL) private var openURL
    
    @Environment(\.dismiss) private var dismiss
    var isFromSavedList: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let urlString = article.urlToImage, let url = URL(string: urlString) {
                    CacheAsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                                .clipped()
                        case .failure(let error):
                            Text("Error: \(error.localizedDescription)")
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                Text(article.title)
                    .font(.title)
                    .bold()
                
                if let desc = article.description {
                    Text(desc)
                        .font(.body)
                }
                
                HStack {
                    Button {
                        if let url = URL(string: article.url) {
                            openURL(url)
                        }
                    } label: {
                        Label("Read Article", systemImage: "safari")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    if isFromSavedList {
                        Button(role: .destructive) {
                            if let saved = try? context.fetch(FetchDescriptor<SavedArticle>()).first(where: { $0.url == article.url }) {
                                context.delete(saved)
                                dismiss()
                            }
                        } label: {
                            Label("Mark as Read", systemImage: "bookmark.slash")
                        }
                        .buttonStyle(.bordered)
                    } else {
                        Button {
                            let alreadySaved = (try? context.fetch(FetchDescriptor<SavedArticle>()))?.contains(where: { $0.url == article.url }) ?? false
                            if !alreadySaved {
                                let saved = SavedArticle(article: article)
                                context.insert(saved)
                                print("Saving article: \(article.title)")
                                Task {
                                    let fetched = try? context.fetch(FetchDescriptor<SavedArticle>())
                                    print("Now saved: \(fetched?.count ?? 0)")
                                }
                            }
                        } label: {
                            Label("Read Later", systemImage: "bookmark")
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ArticleDetailView(article: PreviewData.loadNewsFeed()[0])
}
