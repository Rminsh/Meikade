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
                .aspectRatio(contentMode: .fit)
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(radius: 1)
            }
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.customFont(style: .body))
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .foregroundStyle(.primary)
                
                Text(item.subtitle)
                    .font(.customFont(style: .body))
                    .foregroundStyle(.secondary)
            }
            .frame(width: 130, alignment: .leading)
            .frame(maxHeight: .infinity)
        }
        #if !os(visionOS)
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
            title: "Test\ntest",
            subtitle: "test",
            heightRatio: 1,
            image: "https://meikade.com/offlines/thumbs/28.png",
            color: nil,
            link: "page:/poet?id=28\\u0026poemId=21338",
            type: "normal"
        )
    )
}
