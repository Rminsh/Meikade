//
//  VersesView.swift
//  WidgetExtension
//
//  Created by Armin on 1/10/24.
//

import SwiftUI
import WidgetKit

struct VersesView {
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
}
 
extension VersesView: View {
    var body: some View {
        Group {
            if #available(macOS 14.0, iOS 17.0, watchOS 10.0, *) {
                content
                    .containerBackground(for: .widget) {
                        backCover
                    }
            } else {
                ZStack {
                    backCover
                    
                    content
                        .padding()
                }
            }
        }
    }
    
    var backCover: some View {
        Image(.cover)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .blur(radius: entry.poem == nil ? 0 : 2)
            .padding(-10)
    }
    
    var content: some View {
        VStack {
            if let poem = entry.poem {
                VStack {
                    ForEach(poem.verses, id: \.id) { verse in
                        if let verseText = verse.text {
                            Text(verseText)
                                .customFont(name: .dimaShekasteh, style: .callout)
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
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                    
                    Spacer()
                    
                    Text(poem.poet.name)
                        .foregroundStyle(.secondary)
                        .customFont(style: .caption2, weight: .bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                }
                .dynamicTypeSize(.xSmall)
            }
        }
        .foregroundStyle(.white)
        .environment(\.layoutDirection, .rightToLeft)
    }
}

@available(iOS 17.0, *)
#Preview(as: .systemSmall) {
    VersesWidget()
} timeline: {
    VersesEntry(date: .now, poem: .placeholder)
}
