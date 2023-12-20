//
//  ContentView.swift
//  Meikade
//
//  Created by Armin on 12/20/23.
//

import NukeUI
import SwiftUI

struct ExploreView {
    
    @State var explore: Explore? = nil
    
    func getExplore() async {
        let service = MeikadeService()
        do {
            explore = try await service.getExplore()
        } catch {
            print(error)
        }
    }
}

extension ExploreView: View {
    var body: some View {
        NavigationStack {
            List {
                if let sections = explore?.sections {
                    ForEach(sections, id: \.section) { section in
                        Section {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(section.modelData, id: \.title) { item in
                                        if item.type == "fullback" {
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
                                                
                                                Text(item.title)
                                                    .font(.headline)
                                                    .fontWeight(.medium)
                                                    .foregroundStyle(.white)
                                            }
                                            .frame(width: 150, height: 150)
                                            .clipShape(RoundedRectangle(cornerRadius: 7))
                                        } else {
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
                                                .clipShape(RoundedRectangle(cornerRadius: 7))
                                                .shadow(radius: 1)
                                                
                                                VStack(alignment: .leading) {
                                                    Text(item.title)
                                                        .font(.headline)
                                                        .fontWeight(.semibold)
                                                        .lineLimit(2)
                                                        .foregroundStyle(.primary)
                                                    
                                                    Text(item.subtitle)
                                                        .foregroundStyle(.secondary)
                                                }
                                                .frame(width: 130, height: 80, alignment: .leading)
                                            }
                                            .padding()
                                            .background(
                                                .quinary,
                                                in: RoundedRectangle(cornerRadius: 3)
                                            )
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        } header: {
                            Text(section.section)
                                .padding(.horizontal)
                                .padding(.bottom, 2)
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(.init())
                        .listRowSeparatorTint(.clear)
                    }
                }
            }
            #if !os(macOS)
            .listStyle(.grouped)
            #endif
            .navigationTitle("می‌کده")
        }
        .task {
            await getExplore()
        }
    }
}

#Preview {
    ExploreView()
        .environment(\.locale, .init(identifier: "fa"))
        .environment(\.layoutDirection, .rightToLeft)
}
