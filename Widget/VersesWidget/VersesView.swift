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
                content
                    .padding()
                    .background(backCover)
            }
        }
    }
    
    var backCover: some View {
        Group {
            if let image = entry.image {
                Group {
                    #if os(macOS)
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    #else
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    #endif
                }
            } else {
                Image(.cover)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .blur(radius: entry.poem == nil ? 0 : 4)
        .padding(-10)
        .overlay(Color.black.opacity(0.35))
    }
    
    @MainActor
    var content: some View {
        VStack {
            if let poem = entry.poem {
                VStack {
                    ForEach(poem.verses, id: \.id) { verse in
                        if let verseText = verse.text {
                            Text(verseText)
                                .font(.customFont(name: .dimaShekasteh, style: .callout))
                                .lineLimit(1)
                                .minimumScaleFactor(0.4)
                                .shadow(radius: 5)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: verse.alignment
                                )
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                HStack {
                    Text(poem.poem.title)
                        .foregroundStyle(.secondary)
                        .font(.customFont(style: .caption2))
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                    
                    Spacer()
                    
                    Text(poem.poet.name)
                        .foregroundStyle(.secondary)
                        .font(.customFont(style: .caption2, weight: .bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                }
                .dynamicTypeSize(.xSmall)
            }
        }
        .foregroundStyle(.white)
        .environment(\.layoutDirection, .rightToLeft)
        .shadow(radius: 2)
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
