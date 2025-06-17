//
//  PreviewContainer.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 17/06/2025.
//

import Foundation
import SwiftData

let previewContainer : ModelContainer = {
    let modelContainer : ModelContainer  = try! ModelContainer(for: SavedArticle.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    return modelContainer
}()
