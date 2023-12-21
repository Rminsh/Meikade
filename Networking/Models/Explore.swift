//
//  Explore.swift
//  Meikade
//
//  Created by Armin on 12/20/23.
//

import Foundation

// MARK: - Explore
public struct Explore: Codable {
    let sections: [ExploreSection]
    
    enum CodingKeys: String, CodingKey {
        case sections = "result"
    }
    
    public init(sections: [ExploreSection]) {
        self.sections = sections
    }
}

// MARK: - Result
public struct ExploreSection: Codable {
    let id = UUID()
    let type, color, section: String
    let background: Bool
    let heightRatio: Int
    let modelData: [ExploreSectionItem]
    
    enum CodingKeys: String, CodingKey {
        case type, color, section, background, heightRatio, modelData
    }
    
    public init(
        type: String,
        color: String,
        section: String,
        background: Bool,
        heightRatio: Int,
        modelData: [ExploreSectionItem]
    ) {
        self.type = type
        self.color = color
        self.section = section
        self.background = background
        self.heightRatio = heightRatio
        self.modelData = modelData
    }
}

// MARK: - ModelDatum
public struct ExploreSectionItem: Codable {
    let id = UUID()
    let title, subtitle: String
    let heightRatio: Double
    let image: String
    let color: String?
    let link: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case title, subtitle
        case heightRatio
        case image, color, link, type
    }
    
    public init(
        title: String,
        subtitle: String,
        heightRatio: Double,
        image: String,
        color: String? = nil,
        link: String,
        type: String
    ) {
        self.title = title
        self.subtitle = subtitle
        self.heightRatio = heightRatio
        self.image = image
        self.color = color
        self.link = link
        self.type = type
    }
}
