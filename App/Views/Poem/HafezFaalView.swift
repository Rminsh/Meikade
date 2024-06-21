//
//  HafezFaalView.swift
//  Meikade
//
//  Created by Armin on 1/6/24.
//

import SwiftUI

struct HafezFaalView {
    @State private var showPoem = false
    @State private var selectedPoem: Int? = nil
    @Namespace var container
}

extension HafezFaalView: View {
    var body: some View {
        VStack(spacing: 0) {
            BookSelectorView(
                showDetail: $showPoem,
                selectedPoem: $selectedPoem
            )
            .background {
                if #available(iOS 18.0, macOS 15.0, visionOS 2.0, *) {
                    Color.clear
                        .matchedTransitionSource(id: 1, in: container)
                }
            }
            
            Text("Make a wish and tap for a sign")
                .font(.customFont(name: .shekasteh, style: .subheadline))
                .foregroundStyle(.white)
                .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            #if !os(visionOS)
            Image(.cover)
                .resizable()
                .grayscale(1)
                .aspectRatio(contentMode: .fill)
                .blur(radius: 5)
                .padding(-8)
                .ignoresSafeArea(.all)
            #endif
        }
        .navigationDestination(isPresented: $showPoem) {
            if #available(iOS 18.0, macOS 15.0, visionOS 2.0, *) {
                PoemView(poemType: .poem(id: selectedPoem ?? 0))
                    .navigationTransition(.zoom(sourceID: 1, in: container))
            } else {
                PoemView(poemType: .poem(id: selectedPoem ?? 0))
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
