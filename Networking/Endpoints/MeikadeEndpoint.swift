//
//  MeikadeEndpoint.swift
//  Meikade
//
//  Created by Armin on 12/20/23.
//

import Foundation

enum MeikadeEndpoint {
    case home
    case explore
    case poet(poetID: Int)
    case poets(limit: Int, offset: Int, typeID: Int)
    case poetsSimple(limit: Int, offset: Int)
    case poetTypes
    case poem(poemID: Int, verseLimit: Int, verseOffset: Int)
    case poems(poetID: Int, categoryID: Int, offset: Int)
    case randomPoem(verseLimit: Int, verseOffset: Int, poetID: Int)
    case verses(poemID: Int)
    case category(categoryID: Int)
    case categories(poetID: Int, parentID: Int)
}

extension MeikadeEndpoint: Endpoint {
    var path: String {
        switch self {
        case .home:
            return "/api/main/home"
        case .explore:
            return "/api/main/explore"
        case .poet:
            return "/api/main/poet"
        case .poets:
            return "/api/main/poets"
        case .poetsSimple:
            return "/api/main/poets-simple"
        case .poetTypes:
            return "/api/main/types"
        case .poem:
            return "/api/main/poem"
        case .poems:
            return "/api/main/poems"
        case .randomPoem:
            return "/api/main/random-poem"
        case .verses:
            return "/api/main/verses"
        case .category:
            return "/api/main/category"
        case .categories:
            return "/api/main/categories"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var header: [String : String]? {
        switch self {
        case .explore:
            return ["Accept-Language": "fa"]
        default:
            return nil
        }
    }
    
    var urlParams: [URLQueryItem]? {
        switch self {
        case .poet(let poetID):
            return [
                .init(name: "poet_id", value: String(poetID)),
            ]
        case .poets(let limit, let offset, let typeID):
            return [
                .init(name: "limit", value: String(limit)),
                .init(name: "offset", value: String(offset)),
                .init(name: "type_id", value: String(typeID)),
            ]
        case .poetsSimple(let limit, let offset):
            return [
                .init(name: "limit", value: String(limit)),
                .init(name: "offset", value: String(offset)),
            ]
        case .poem(let poemID, let verseLimit, let verseOffset):
            return [
                .init(name: "poem_id", value: String(poemID)),
                .init(name: "verse_limit", value: String(verseLimit)),
                .init(name: "verse_offset", value: String(verseOffset)),
            ]
        case .poems(let poetID, let categoryID, let offset):
            return [
                .init(name: "poet_id", value: String(poetID)),
                .init(name: "category_id", value: String(categoryID)),
                .init(name: "offset", value: String(offset)),
            ]
        case .randomPoem(let verseLimit, let verseOffset, let poetID):
            return [
                .init(name: "verse_limit", value: String(verseLimit)),
                .init(name: "verse_offset", value: String(verseOffset)),
                .init(name: "poet_id", value: String(poetID)),
            ]
        case .verses(let poemID):
            return [
                .init(name: "poem_id", value: String(poemID))
            ]
        case .category(let categoryID):
            return [
                .init(name: "category_id", value: String(categoryID))
            ]
        case .categories(let poetID, let parentID):
            return [
                .init(name: "poet_id", value: String(poetID)),
                .init(name: "parent_id", value: String(parentID))
            ]
        default:
            return nil
        }
    }
    
    var body: [String : Any]? {
        return nil
    }
}
