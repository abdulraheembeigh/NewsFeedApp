//
//  NewsListView.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 16/06/2025.
//

import SwiftUI


struct NewsListView: View {
    @State var viewModel = NewsFeedViewModel()
    @State private var showCategoryPicker = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 40) {
                            ForEach(viewModel.articles) { article in
                                NewsCardView(article: article)
                                    .scrollTransition { content, phase in
                                        content
                                            .rotation3DEffect(.degrees(phase.isIdentity ? 0 : 60), axis: (x: -1, y: 1, z: 0), perspective: 0.5)
                                            .rotationEffect(.degrees(phase.isIdentity ? 0 : -30))
                                            .offset(x: phase.isIdentity ? 0 : -150)
                                            .blur(radius: phase.isIdentity ? 0 : 8)
                                            .scaleEffect(phase.isIdentity ? 1 : 0.92)
                                    }
                            }
                        }
                        .frame(maxWidth: 600)
                        .padding(.top, 30)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle(viewModel.selectedCategory.displayName + " News")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Select Category", selection: $viewModel.selectedCategory) {
                            ForEach(NewsCategory.allCases) { category in
                                Text(category.displayName).tag(category)
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .task {
                await viewModel.fetchArticles()
            }
        }
    }
}
#Preview {
    NewsListView()
}

