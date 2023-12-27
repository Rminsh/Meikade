//
//  Poet.swift
//  Meikade
//
//  Created by Armin on 12/25/23.
//

import Foundation

// MARK: - Poet
struct Poet: Codable, Hashable {
    let id: Int?
    let username: String?
    let name: String?
    let title: String?
    let description: String?
    let image: String
    let wikipedia: String?
    let color: String
    let views: Int?
    let types: [PoetType]?
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
    let modelData: [Poet]
}
