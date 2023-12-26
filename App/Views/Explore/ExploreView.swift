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
            content
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
    
    var content: some View {
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
                            .frame(maxWidth: 500)
                            .frame(maxWidth: .infinity, alignment: .center)
                            #if os(iOS)
                            .padding(.horizontal)
                            #endif
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
                            .scrollClipDisabled()
                        }
                    } header: {
                        Text(section.section)
                            .customFont(style: .body)
                            #if os(iOS)
                            .padding(.horizontal)
                            #endif
                            .padding(.bottom, 2)
                            .listRowSeparator(.hidden)
                            .listSectionSeparator(.hidden)
                    }
                    .listRowInsets(.init())
                    .listRowSeparator(.hidden)
                    .listSectionSeparator(.hidden)
                    .listSectionSeparatorTint(Color.clear)
                    .listRowSeparatorTint(Color.clear)
                }
            }
        }
        #if os(macOS)
        .listStyle(.plain)
        #else
        .listStyle(.grouped)
        #endif
    }
}

#Preview {
    ExploreView()
        .environment(\.locale, .init(identifier: "fa"))
        .environment(\.layoutDirection, .rightToLeft)
}
