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
            .toolbar {
                ToolbarItem(placement: .secondaryAction) {
                    Image("Meikade")
                        #if os(visionOS)
                        .font(.system(size: 42))
                        #else
                        .font(.largeTitle)
                        #endif
                }
            }
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
