//
//  Extensions+Font.swift
//  Meikade
//
//  Created by Armin on 12/20/23.
//

import SwiftUI

#if os(macOS)
public typealias UXFont = NSFont
#else
public typealias UXFont = UIFont
#endif

enum Fonts: String, CaseIterable {
    case vazirmatn = "Vazirmatn"
    case dimaNastaligh = "Dima Nastaligh Tahriri"
    case dimaShekasteh = "Dima Shekasteh Free"
    
    var extraPointSize: CGFloat {
        switch self {
        case .vazirmatn:
            return 1
        case .dimaNastaligh:
            return 1.5
            
        case .dimaShekasteh:
            return 1.2
        }
    }
    
    static func getValue(name: String) -> Fonts? {
        if let fontEnum = Fonts(rawValue: name) {
            return fontEnum
        }
        return nil
    }
}

struct CustomFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory

    var name: Fonts
    var style: UXFont.TextStyle
    var weight: Font.Weight = .regular

    func body(content: Content) -> some View {
        return content
            .font(
                .custom(name.rawValue, size: UXFont.preferredFont(forTextStyle: style).pointSize * name.extraPointSize)
                .weight(weight)
            )
    }
}

extension View {
    func customFont(
        name: Fonts = Fonts.vazirmatn,
        style: UXFont.TextStyle,
        weight: Font.Weight = .regular
    ) -> some View {
        return self.modifier(CustomFont(name: name, style: style, weight: weight))
    }
}
