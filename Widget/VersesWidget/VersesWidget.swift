//
//  VersesWidget.swift
//  Widget
//
//  Created by Armin on 1/6/24.
//

import WidgetKit
import SwiftUI

struct VersesWidget: Widget {
    let kind: String = "VersesWidget"
    
    let families: [WidgetFamily] = [
            .systemSmall,
            .systemMedium,
        ]

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: VersesProvider()) { entry in
            VersesWidgetEntryView(entry: entry)
        }
        .supportedFamilies(families)
    }
}

struct VersesWidgetEntryView : View {
    var entry: VersesEntry

    func getPosition(_ position: Int) -> Alignment {
        switch position {
        case 0:
            return .leading
        case 1:
            return .trailing
        case 2:
            return .center
        case -5:
            return .leading
        default:
            return .leading
        }
    }
    
    var body: some View {
        VStack {
            if let poem = entry.poem {
                VStack {
                    ForEach(poem.verses, id: \.id) { verse in
                        if let verseText = verse.text {
                            Text(verseText)
                                .customFont(name: .dimaShekasteh, style: .body)
                                .lineLimit(1)
                                .minimumScaleFactor(0.4)
                                .shadow(radius: 5)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: getPosition(verse.position)
                                )
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                HStack {
                    Text(poem.poem.title)
                        .foregroundStyle(.secondary)
                        .customFont(style: .caption2)
                    
                    Spacer()
                    
                    Text(poem.poet.name)
                        .foregroundStyle(.secondary)
                        .customFont(style: .caption2, weight: .bold)
                }
                .dynamicTypeSize(.xSmall)
            }
        }
        .foregroundStyle(.white)
        .containerBackground(for: .widget) {
            Image(.cover)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 2)
                .padding(-10)
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview(as: .systemSmall) {
    VersesWidget()
} timeline: {
    VersesEntry(date: .now, poem: .placeholder)
}
