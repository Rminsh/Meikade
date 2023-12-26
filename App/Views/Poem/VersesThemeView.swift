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
                    .padding(4)
                    .multilineTextAlignment(.center)
                    .customFont(
                        name: Fonts(rawValue: font.rawValue) ?? .vazirmatn,
                        style: .body
                    )
                    
                }
                .buttonBorderShape(.roundedRectangle(radius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: versesFont == font.rawValue ? 2 : 0)
                }
            }
        }
        .padding()
    }
}

#Preview {
    PoemView(verses: Verse.preview, showVersesTheme: true)
}
