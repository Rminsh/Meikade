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

struct CustomFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory

    var name: Fonts
    var style: UXFont.TextStyle
    var weight: Font.Weight = .regular

    func body(content: Content) -> some View {
        return content
            .font(
                .custom(name.rawValue, size: UXFont.preferredFont(forTextStyle: style).pointSize * name.pointSize)
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
