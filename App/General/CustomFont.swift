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

struct CustomFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory

    var name: String
    var style: UXFont.TextStyle
    var weight: Font.Weight = .regular

    func body(content: Content) -> some View {
        return content
            .font(
                .custom(name, size: UXFont.preferredFont(forTextStyle: style).pointSize)
                .weight(weight)
            )
    }
}

extension View {
    func customFont(
        name: String = "Vazirmatn",
        style: UXFont.TextStyle,
        weight: Font.Weight = .regular
    ) -> some View {
        return self.modifier(CustomFont(name: name, style: style, weight: weight))
    }
}