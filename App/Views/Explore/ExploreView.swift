//
//  ContentView.swift
//  Meikade
//
//  Created by Armin on 12/20/23.
//

import SwiftUI

struct ExploreView {
    
    @State var explore: Explore? = nil
    @State private var path = NavigationPath()
    
    @State var loading: Bool = false
    @State var emptyState: EmptyState? = nil
    
    func getExplore() async {
        loading = true
        
        let service = MeikadeService()
        do {
            explore = try await service.getExplore()
            if explore?.sections.isEmpty ?? false {
                emptyState = .empty(
                    icon: "text.book.closed",
                    title: "Nothing here"
                )
            }
        } catch {
            emptyState = .network(subtitle: error.localizedDescription)
            #if DEBUG
            print(error)
            #endif
        }
        
        loading = false
    }
}

extension ExploreView: View {
    var body: some View {
        NavigationStack(path: $path) {
            content
                .navigationTitle("")
                #if os(iOS)
                .toolbarTitleDisplayMode(.inline)
                #endif
                .overlay {
                    emptyStateView
                }
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
                                    Button {
                                        path.append(item.link)
                                    } label: {
                                        ExploreStaticView(item: item)
                                    }
                                    #if os(visionOS)
                                    .buttonBorderShape(.roundedRectangle(radius: 21))
                                    #endif
                                    .buttonStyle(.plain)
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
                                    ForEach(section.modelData, id: \.id) { item in
                                        Button {
                                            path.append(item.link)
                                        } label: {
                                            ExploreItemView(item: item)
                                        }
                                        #if os(visionOS)
                                        .buttonBorderShape(.roundedRectangle(radius: 21))
                                        #else
                                        .buttonStyle(.plain)
                                        #endif
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
                    .listRowBackground(Color.clear)
                }
            }
        }
        #if os(macOS)
        .listStyle(.plain)
        #else
        .listStyle(.grouped)
        #endif
        .navigationDestination(for: String.self) { link in
            RouterView(link: link)
        }
    }
    
    var emptyStateView: some View {
        Group {
            if !loading && explore == nil, let emptyState {
                ContentUnavailableView {
                    Label(
                        LocalizedStringKey(emptyState.title),
                        systemImage: emptyState.icon
                    )
                    .customFont(style: .largeTitle)
                } description: {
                    Text(LocalizedStringKey(emptyState.subtitle))
                        .customFont(style: .headline)
                } actions: {
                    if case EmptyState.network = emptyState {
                        Button {
                            Task {
                                await getExplore()
                            }
                        } label: {
                            Text("Try again")
                                .customFont(style: .body)
                        }
                    }
                }
            } else if loading {
                ProgressView()
            }
        }
    }
}

#Preview {
    ExploreView()
        .environment(\.locale, .init(identifier: "fa"))
        .environment(\.layoutDirection, .rightToLeft)
}
