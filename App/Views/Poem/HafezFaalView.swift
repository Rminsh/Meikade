//
//  HafezFaalView.swift
//  Meikade
//
//  Created by Armin on 1/6/24.
//

import SwiftUI

struct HafezFaalView {
    @State private var selectedPoem: Int? = nil
    @Namespace var container
}

extension HafezFaalView: View {
    var body: some View {
        VStack(spacing: 0) {
            BookSelectorView(selectedPoem: $selectedPoem)
                .background {
                    if #available(iOS 18.0, macOS 15.0, visionOS 2.0, watchOS 11.0, *) {
                        Color.clear
                            .matchedTransitionSource(id: 1, in: container)
                    }
                }
            
            Text("Make a wish and tap for a sign")
                #if os(watchOS)
                .font(.customFont(name: .shekasteh, style: .caption2))
                #else
                .font(.customFont(name: .shekasteh, style: .subheadline))
                .padding(.bottom)
                #endif
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        #if os(watchOS)
        .ignoresSafeArea(edges: .bottom)
        .containerBackground(for: .navigation) {
            Image(.cover)
                .aspectRatio(contentMode: .fill)
                .grayscale(1)
                .opacity(0.5)
                .blur(radius: 5)
        }
        #elseif !os(visionOS)
        .background {
            Image(.cover)
                .resizable()
                .grayscale(1)
                .aspectRatio(contentMode: .fill)
                .blur(radius: 5)
                .padding(-8)
                .ignoresSafeArea(.all)
        }
        #endif
        .navigationDestination(item: $selectedPoem) { poemID in
            if #available(iOS 18.0, macOS 15.0, visionOS 2.0, watchOS 11.0, *) {
                PoemView(poemType: .poem(id: poemID))
                    #if !os(macOS)
                    .navigationTransition(.zoom(sourceID: 1, in: container))
                    #endif
            } else {
                PoemView(poemType: .poem(id: poemID))
            }
        }
        #if os(macOS)
        .navigationTitle("")
        .toolbarBackground(Color.clear, for: .windowToolbar)
        #else
        .navigationTitle("Hafez Divination")
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

#Preview {
    NavigationStack {
        HafezFaalView()
            .environment(\.locale, .init(identifier: "fa"))
    }
}
