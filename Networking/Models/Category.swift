//
//  Category.swift
//  Meikade
//
//  Created by Armin on 12/25/23.
//

import Foundation
import RegexBuilder

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
    
    var isUnlisted: Bool {
        let categoriesRegex = /page\:\/poet\?id\=(\d+).+catId\=-(\d+)/
        if let result = link.wholeMatch(of: categoriesRegex), let catID = Int(result.2) {
            return catID == 1
        } else {
            return false
        }
    }
}

struct Categories: Codable {
    let modelData: [Category]
}

struct CategoriesResponse: Codable {
    let result: [Categories]
}

struct CategoryResponse: Codable {
    let result: CategoryResult
}

struct CategoryResult: Codable {
    let category: CategorySection
    let parent: CategorySection
    let poet: CategorySectionPoet
}

struct CategorySection: Codable {
    let id: Int
    let title: String
}

struct CategorySectionPoet: Codable {
    let id: Int
    let name: String
    let image: String
}
