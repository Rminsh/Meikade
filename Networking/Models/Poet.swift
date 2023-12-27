//
//  Poet.swift
//  Meikade
//
//  Created by Armin on 12/25/23.
//

import Foundation

// MARK: - Poet
struct Poet: Codable {
    let id: Int
    let username: String
    let name: String
    let description: String
    let image: String
    let wikipedia: String
    let color: String
    let views: Int
}

struct PoetTypes: Codable {
    let id: Int
    let name: String
    let nameEN: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case nameEN = "name_en"
    }
}

struct PoetTypesResponse: Codable {
    let result: [PoetTypes]
}
