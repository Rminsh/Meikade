//
//  PoemView.swift
//  Meikade
//
//  Created by Armin on 12/22/23.
//

import SwiftUI

struct PoemView: View {
    
    var verses: [Verse]
    
    var isRTL: Bool {
        verses.first?.text.isRTL ?? false
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(verses, id: \.id) { verse in
                    Text(verse.text)
                        .customFont(
                            name: Fonts.dimaShekasteh.rawValue,
                            style: .title1
                        )
                        .frame(
                            maxWidth: .infinity,
                            alignment: verse.position == 0 ? .leading : .trailing
                        )
                        .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
                }
            }
            .frame(maxWidth: 650)
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}

#Preview {
    PoemView(verses: Verse.preview)
}
