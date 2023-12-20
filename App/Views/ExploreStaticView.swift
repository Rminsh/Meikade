//
//  ExploreStaticView.swift
//  Meikade
//
//  Created by Armin on 12/20/23.
//

import NukeUI
import SwiftUI

struct ExploreStaticView: View {
    var item: ExploreSectionItem
    
    var body: some View {
        ZStack {
            LazyImage(url: URL(string: item.image)) { state in
                if let image = state.image {
                    image
                        .resizable()
                } else {
                    Rectangle()
                        .foregroundStyle(.secondary)
                }
            }
            .aspectRatio(contentMode: .fill)
            .overlay(Color.black.opacity(0.7))
            
            Text(LocalizedStringKey(item.title))
                .font(.headline)
                .fontWeight(.medium)
                .foregroundStyle(.white)
        }
        .frame(width: 150, height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 21))
    }
}

#Preview {
    ExploreStaticView(
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