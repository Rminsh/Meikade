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
        Group {
            if #available(macOS 14.0, iOS 17.0, watchOS 10.0, *) {
                content
                    .containerBackground(.background, for: .widget)
            } else {
                content
            }
        }
    }
    
    var content: some View {
        VStack {
            if let poem = entry.poem {
                VStack {
                    ForEach(poem.verses, id: \.id) { verse in
                        if let verseText = verse.text {
                            Text(verseText)
                                .customFont(name: .dimaShekasteh, style: .body)
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
        .environment(\.layoutDirection, .rightToLeft)
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview(as: .systemSmall) {
    VersesWidget()
} timeline: {
    VersesEntry(
        date: .now,
        poem: .placeholder,
        image: nil
    )
}
