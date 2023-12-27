//
//  Poet.swift
//  Meikade
//
//  Created by Armin on 12/25/23.
//

import Foundation

// MARK: - Poet
struct Poet: Codable, Hashable {
    let id: Int
    let username: String
    let name: String
    let description: String
    let image: String
    let wikipedia: String
    let color: String
    let views: Int
}

struct PoetItem: Codable, Hashable {
    static func == (lhs: PoetItem, rhs: PoetItem) -> Bool {
        rhs.title == rhs.title &&
        rhs.link == lhs.link &&
        rhs.subtitle == lhs.subtitle
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    let title: String
    let subtitle: String
    let color: String
    let image: String
    let link: String
    let heightRatio: Double
    let details: PoetDetails
}

struct PoetDetails: Codable {
    let color: String
    let description: String
    let image: String
    let types: [PoetType]
    let views: Int
    let wikipedia: String
}

// MARK: - Poet type
struct PoetType: Codable, Hashable, Identifiable {
    let id: Int?
    let name: String
    let nameEN: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case nameEN = "name_en"
    }
}

struct PoetTypesResponse: Codable {
    let result: [PoetType]
}

// MARK: - PoetsResponse
struct PoetsResponse: Codable {
    let result: [PoetsResult]

    enum CodingKeys: String, CodingKey {
        case result = "result"
    }
}

struct PoetsResult: Codable {
    let type: String
    let section: String
    let color: String
    let background: Bool
    let modelData: [PoetItem]
}
