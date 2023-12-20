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
            .frame(width: 75, height: 75)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 1)
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .customFont(style: .headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .foregroundStyle(.primary)
                
                Text(item.subtitle)
                    .customFont(style: .body)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 130, height: 80, alignment: .leading)
        }
        .padding()
        .background(
            .quinary,
            in: RoundedRectangle(cornerRadius: 21)
        )
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
