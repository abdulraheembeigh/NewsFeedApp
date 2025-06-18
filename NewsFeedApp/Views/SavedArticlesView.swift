//
//  SavedArticlesView.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 16/06/2025.
//

import SwiftUI
import SwiftData

struct SavedArticlesView: View {
    @Environment(\.modelContext) private var context
    @Query var savedArticles: [SavedArticle]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(savedArticles) { article in
                    let destinationArticle = Article(title: article.title, description: article.articleDescription, url: article.url, urlToImage: article.urlToImage, publishedAt: article.publishedAt, content: article.content)
                    NavigationLink(destination: ArticleDetailView(article: destinationArticle, isFromSavedList: true)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(article.title)
                                .font(.headline)
                            if let desc = article.articleDescription {
                                Text(desc)
                                    .font(.subheadline)
                                    .lineLimit(2)
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        context.delete(savedArticles[index])
                    }
                }
            }
            .navigationTitle("Saved Articles")
            .toolbar {
                EditButton()
            }
        }.onAppear {
            print("Saved Articles Count: \(savedArticles.count)")
            savedArticles.forEach { print("→ \($0.title)") }
        }
    }
}

#Preview {
    SavedArticlesView().modelContainer(previewContainer)
}
