//
//  HomeView.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 16/06/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            NewsListView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            SavedArticlesView()
                .tabItem {
                    Label("Read Later", systemImage: "bookmark")
                }
        }
    }
}

#Preview {
    HomeView().modelContainer(previewContainer)
}
