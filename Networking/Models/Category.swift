//
//  Category.swift
//  Meikade
//
//  Created by Armin on 12/25/23.
//

import Foundation

// MARK: - Category
struct Category: Codable, Hashable {
    let title: String
    let subtitle: String
    let color: String
    let image: String
    let link: String
    let heightRatio: Double
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        rhs.title == rhs.title &&
        rhs.link == lhs.link &&
        rhs.subtitle == lhs.subtitle
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

struct Categories: Codable {
    let modelData: [Category]
}

struct CategoriesResponse: Codable {
    let result: [Categories]
}
