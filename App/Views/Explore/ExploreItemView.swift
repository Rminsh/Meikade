//
//  ExploreItemView.swift
//  Meikade
//
//  Created by Armin on 12/20/23.
//

import NukeUI
import SwiftUI

struct ExploreItemView: View {
    var item: ExploreSectionItem
    
    var body: some View {
        HStack {
            if item.image != "" {
                LazyImage(url: URL(string: item.image)) { state in
                    if let image = state.image {
                        image
                            .resizable()
                    } else {
                        Rectangle()
                            .foregroundStyle(.secondary)
                    }
                }
                .pipeline(.init(configuration: .withDataCache))
                .aspectRatio(contentMode: .fit)
                #if os(watchOS)
                .frame(width: 42, height: 42)
                .clipShape(.circle)
                .padding(.vertical)
                #else
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(radius: 1)
                #endif
            }
            
            VStack(alignment: .leading) {
                Text(item.title)
                    #if os(watchOS)
                    .font(.customFont(style: .caption1))
                    #else
                    .font(.customFont(style: .body))
                    #endif
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .foregroundStyle(.primary)
                
                Text(item.subtitle)
                    #if os(watchOS)
                    .font(.customFont(style: .caption2))
                    #else
                    .font(.customFont(style: .body))
                    #endif
                    .foregroundStyle(.secondary)
            }
            #if !os(watchOS)
            .frame(width: 130, alignment: .leading)
            #endif
            .frame(maxHeight: .infinity)
        }
        #if !os(visionOS) && !os(watchOS)
        .padding()
        #endif
        #if os(iOS)
        .background(
            Color(uiColor: UIColor.secondarySystemGroupedBackground),
            in: RoundedRectangle(cornerRadius: 21)
        )
        #elseif os(macOS)
        .background(
            .quinary,
            in: RoundedRectangle(cornerRadius: 21)
        )
        #endif
    }
}

#Preview {
    ExploreItemView(
        item: .init(
            title: "Test",
            subtitle: "test",
            heightRatio: 1,
            image: "https://meikade.com/offlines/thumbs/28.png",
            color: nil,
            link: "page:/poet?id=28\\u0026poemId=21338",
            type: "normal"
        )
    )
}
