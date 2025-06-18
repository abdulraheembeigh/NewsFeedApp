//
//  NewsCategory.swift
//  NewsFeedApp
//
//  Created by Abdul Raheem Beigh on 18/06/2025.
//
// MARK: - Category Enum
enum NewsCategory: String, CaseIterable, Identifiable {
    case business, entertainment, general, health, science, sports, technology
    var id: String { rawValue }
    var displayName: String { rawValue.capitalized }
}
