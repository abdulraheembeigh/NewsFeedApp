//
//  NewsFeedAppApp.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 16/06/2025.
//

import SwiftUI
import SwiftData

@main
struct NewsFeedApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: SavedArticle.self)
    }
}
