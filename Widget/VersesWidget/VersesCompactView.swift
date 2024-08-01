//
//  VersesCompactView.swift
//  WidgetExtension
//
//  Created by Armin on 1/15/24.
//

import SwiftUI
import WidgetKit

struct VersesCompactView {
    var entry: VersesEntry
}
 
extension VersesCompactView: View {
    
    var body: some View {
        VStack {
            if let poem = entry.poem {
                VStack {
                    ForEach(poem.verses, id: \.id) { verse in
                        if let verseText = verse.text {
                            Text(verseText)
                                .font(.customFont(name: .dimaShekasteh, style: .body))
                                .lineLimit(1)
                                .minimumScaleFactor(0.55)
                                .shadow(radius: 5)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: verse.alignment
                                )
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .foregroundStyle(.white)
        .containerBackground(.background, for: .widget)
        .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview(as: .systemSmall) {
    VersesWidget()
} timeline: {
    VersesEntry(
        date: .now,
        poem: .placeholder,
        image: nil
    )
}
