//
//  Fonts.swift
//  Meikade
//
//  Created by Armin on 12/26/23.
//

import Foundation

enum Fonts: String, CaseIterable {
    case behdad = "behdad"
    case dimaShekasteh = "Dima Shekasteh Free"
    case mikhak = "mikhak"
    case shekasteh = "Shekasteh_Beta"
    case tanha = "Tanha"
    case vazirmatn = "Vazirmatn"
    
    static func getValue(name: String) -> Fonts? {
        if let fontEnum = Fonts(rawValue: name) {
            return fontEnum
        }
        return nil
    }
    
    var source: URL? {
        switch self {
        case .behdad:
            return URL(string: "https://github.com/font-store/BehdadFont")!
        case .dimaShekasteh:
            return URL(string: "https://github.com/balvardi/dima")!
        case .mikhak:
            return URL(string: "https://github.com/aminabedi68/Mikhak")!
        case .shekasteh:
            return nil
        case .tanha:
            return URL(string: "https://github.com/rastikerdar/tanha-font")!
        case .vazirmatn:
            return URL(string: "https://github.com/rastikerdar/vazirmatn")!
        }
    }
    
    var pointSize: CGFloat {
        switch self {
        case .dimaShekasteh, .shekasteh:
            return 1.4
        default:
            return 1
        }
    }
    
    var surroundedCharacter: String {
        switch self {
        case .dimaShekasteh, .shekasteh:
            return " "
        default:
            return ""
        }
    }
}
