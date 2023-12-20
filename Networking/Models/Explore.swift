//
//  Explore.swift
//  Meikade
//
//  Created by Armin on 12/20/23.
//

import Foundation

// MARK: - Explore
struct Explore: Codable {
    let sections: [ExploreSection]
    
    enum CodingKeys: String, CodingKey {
        case sections = "result"
    }
}

// MARK: - Result
struct ExploreSection: Codable {
    let type, color, section: String
    let background: Bool
    let heightRatio: Int
    let modelData: [ExploreSectionItem]
}

// MARK: - ModelDatum
struct ExploreSectionItem: Codable {
    let title, subtitle: String
    let heightRatio: Double
    let image: String
    let color: String?
    let link: String
    let type: String
}
