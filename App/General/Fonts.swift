//
//  Fonts.swift
//  Meikade
//
//  Created by Armin on 12/26/23.
//

import Foundation

enum Fonts: String, CaseIterable {
    case behdad = "behdad"
    case mikhak = "mikhak"
    case tanha = "Tanha"
    case vazirmatn = "Vazirmatn"
    
    static func getValue(name: String) -> Fonts? {
        if let fontEnum = Fonts(rawValue: name) {
            return fontEnum
        }
        return nil
    }
    
    var source: URL {
        switch self {
        case .behdad:
            return URL(string: "https://github.com/font-store/BehdadFont")!
        case .mikhak:
            return URL(string: "https://github.com/aminabedi68/Mikhak")!
        case .tanha:
            return URL(string: "https://github.com/rastikerdar/tanha-font")!
        case .vazirmatn:
            return URL(string: "https://github.com/rastikerdar/vazirmatn")!
        }
    }
}
