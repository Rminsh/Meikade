//
//  Poem.swift
//  Meikade
//
//  Created by Armin on 12/25/23.
//

import Foundation

struct Poem: Codable {
    let poem: PoemDetail
    let poet: Poet
    let verses: [Verse]
}

// MARK: - PoemDetail
struct PoemDetail: Codable {
    let id: Int
    let poetID: Int?
    let categoryID: Int?
    let title: String
    let phrase: String?
    let views: Int

    enum CodingKeys: String, CodingKey {
        case id
        case poetID = "poet_id"
        case categoryID = "category_id"
        case title
        case phrase
        case views
    }
}

struct PoemResponse: Codable {
    let result: Poem
}

struct PoemsResponse: Codable {
    let result: [PoemDetail]
}
