//
//  ExploreSectionView.swift
//  Meikade
//
//  Created by Armin on 12/31/23.
//

import SwiftUI

struct ExploreSectionView<Content: View>: View {
    let content: () -> Content
    
    var body: some View {
        Group {
            if #available(iOS 17.0, macOS 14.0, visionOS 1.0, *) {
                ScrollView(.horizontal) {
                    content()
                }
                .scrollClipDisabled()
            } else {
                ScrollView(.horizontal) {
                    content()
                }
            }
        }
    }
}

#Preview {
    ExploreSectionView {
        HStack {
            ForEach(0...20, id: \.self) { _ in
                Image(systemName: "person.crop.circle")
                    .font(.title)
                    .padding()
                    .background(.quaternary)
            }
        }
        .padding()
    }
}
