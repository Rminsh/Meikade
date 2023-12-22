//
//  ContentView.swift
//  Meikade
//
//  Created by Armin on 12/20/23.
//

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
                    ForEach(sections, id: \.id) { section in
                        Section {
                            if section.type == "static" {
                                HStack {
                                    ForEach(section.modelData, id: \.id) { item in
                                        ExploreStaticView(item: item)
                                            .padding(.horizontal, 4)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                            } else {
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(section.modelData, id: \.title) { item in
                                            ExploreItemView(item: item)
                                        }
                                    }
                                    #if os(iOS)
                                    .padding(.horizontal)
                                    #endif
                                }
                            }
                        } header: {
                            Text(section.section)
                                .customFont(style: .body)
                                #if os(iOS)
                                .padding(.horizontal)
                                #endif
                                .padding(.bottom, 2)
                        }
                        .listRowInsets(.init())
                        .listSectionSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowSeparatorTint(.clear)
                    }
                }
            }
            #if os(macOS)
            .listStyle(.plain)
            #else
            .listStyle(.grouped)
            #endif
            .navigationTitle("")
            #if os(iOS)
            .toolbarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .principal) {
                    logo
                }
                #else
                ToolbarItem(placement: .secondaryAction) {
                    logo
                }
                #endif
            }
        }
        .task {
            await getExplore()
        }
    }
    
    var logo: some View {
        Image("Meikade")
            #if os(visionOS)
            .font(.system(size: 42))
            #elseif os(iOS)
            .font(.title)
            #else
            .font(.largeTitle)
            #endif
    }
}

#Preview {
    ExploreView()
        .environment(\.locale, .init(identifier: "fa"))
        .environment(\.layoutDirection, .rightToLeft)
}