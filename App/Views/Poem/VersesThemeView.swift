//
//  VersesThemeView.swift
//  Meikade
//
//  Created by Armin on 12/25/23.
//

import SwiftUI

struct VersesThemeView: View {
    
    @AppStorage("versesFont") var versesFont: String = Fonts.vazirmatn.rawValue
    
    var body: some View {
        HStack {
            ForEach(Fonts.allCases, id:\.hashValue) { font in
                Button {
                    versesFont = font.rawValue
                } label: {
                    VStack {
                        Text("Font")
                        Text("قلم")
                    }
                    #if os(iOS)
                    .padding()
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    #else
                    .padding(4)
                    #endif
                    .customFont(
                        name: Fonts(rawValue: font.rawValue) ?? .vazirmatn,
                        style: .subheadline
                    )
                }
                .buttonStyle(.bordered)
                #if os(visionOS)
                .buttonBorderShape(.roundedRectangle(radius: 8))
                #endif
                .overlay {
                    #if os(iOS)
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(.accent, lineWidth: versesFont == font.rawValue ? 2 : 0)
                    #else
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: versesFont == font.rawValue ? 2 : 0)
                    #endif
                }
            }
        }
        .padding()
    }
}

#Preview {
    PoemView(verses: Verse.preview, showVersesTheme: true)
}
