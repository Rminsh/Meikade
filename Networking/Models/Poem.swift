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

extension Poem {
    private static let poemKey = "cachedPoemKey"
    
    static func loadCachedPoem() -> Poem? {
        if let data = UserDefaults.standard.data(forKey: poemKey),
           let cachedPoem = try? JSONDecoder().decode(Poem.self, from: data) {
            return cachedPoem
        }
        return nil
    }
    
    static func cachePoem(_ poem: Poem?) {
        if let poem, let data = try? JSONEncoder().encode(poem) {
            UserDefaults.standard.set(data, forKey: poemKey)
        } else {
            UserDefaults.standard.removeObject(forKey: poemKey)
        }
    }
}

extension Poem {
    static let placeholder: Poem = .init(
        poem: .init(
            id: 1,
            poetID: nil,
            categoryID: nil,
            title: "غزل شمارهٔ ۳۱۳",
            phrase: nil,
            views: 0
        ),
        poet: .init(
            id: 0,
            username: "حافظ",
            name: "حافظ",
            description: "",
            image: "",
            wikipedia: "",
            color: "",
            views: 0,
            types: nil,
            categories: nil
        ),
        verses: [
            .init(
                verseOrder: 1,
                position: 0,
                text: "بازآی ساقیا که هواخواه خدمتم"
            ),
            .init(
                verseOrder: 2,
                position: 1,
                text: "مشتاق بندگی و دعاگوی دولتم"
            )
        ]
    )
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

enum PoemType {
    case poem(id: Int)
    case random(poetID: Int? = nil)
}
