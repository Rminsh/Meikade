//
//  Extensions+Font.swift
//  Meikade
//
//  Created by Armin on 12/20/23.
//

import SwiftUI

extension UXFont {
    static func custom(name: Fonts = .vazirmatn, style: UXFont.TextStyle) -> UXFont {
        return UXFont(
            name: name.rawValue,
            size: UXFont.preferredFont(forTextStyle: style).pointSize * name.pointSize
        )!
    }
}

extension Font {
    static func customFont(
        name: Fonts = Fonts.vazirmatn,
        style: UXFont.TextStyle,
        weight: Font.Weight = .regular
    ) -> Font {
        return Font
            .custom(
                name.rawValue,
                size: UXFont.preferredFont(forTextStyle: style).pointSize * name.pointSize
            )
            .weight(weight)
    }
}
