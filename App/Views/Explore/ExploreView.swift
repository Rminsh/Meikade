//
//  ContentView.swift
//  Meikade
//
//  Created by Armin on 12/20/23.
//

import SwiftUI

struct ExploreView {
    
    @State var exploreSections: [ExploreSection] = []
    @State private var path = NavigationPath()
    
    @State var loading: Bool = false
    @State var emptyState: EmptyState? = nil
    
    @Namespace var container
    
    func getExplore() async {
        loading = true
        
        let service = MeikadeService()
        do {
            let result = try await service.getExplore()
            exploreSections = result.filter {
                $0.section != "کاوش در لیست‌های کاربران" &&
                $0.section != "User lists" &&
                $0.type != "static"
            }
            if exploreSections.isEmpty {
                emptyState = .exploreEmpty
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
                #if os(iOS) || os(watchOS)
                .navigationTitle("Meikade")
                .navigationBarTitleDisplayMode(.inline)
                #else
                .navigationTitle("")
                #endif
                .overlay {
                    emptyStateView
                }
                .toolbar {
                    #if os(iOS)
                    ToolbarItem(placement: .principal) {
                        logo
                    }
                    #elseif !os(watchOS)
                    ToolbarItem(placement: .secondaryAction) {
                        logo
                    }
                    #endif
                    
                    #if os(watchOS)
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            path.append("page:/poem/random")
                        } label: {
                            Label("Random Poem", systemImage: "shuffle")
                        }
                    }
                    #else
                    ToolbarItem(placement: .navigation) {
                        Button {
                            path.append("page:/poem/random")
                        } label: {
                            Label("Random Poem", systemImage: "shuffle")
                        }
                    }
                    #endif
                }
        }
        .task {
            if exploreSections.isEmpty {
                await getExplore()
            }
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
            .foregroundStyle(.accent.gradient)
    }
    
    @MainActor
    var content: some View {
        List {
            ForEach(exploreSections, id: \.id) { section in
                Section {
                    #if os(watchOS)
                    ForEach(section.modelData, id: \.id) { item in
                        Button {
                            path.append(item.link)
                        } label: {
                            ExploreItemView(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                    #else
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(section.modelData, id: \.id) { item in
                                Button {
                                    path.append(item.link)
                                } label: {
                                    if #available(iOS 18.0, macOS 15.0, visionOS 2.0, watchOS 11.0, *) {
                                        ExploreItemView(item: item)
                                            .matchedTransitionSource(id: item.link, in: container)
                                    } else {
                                        ExploreItemView(item: item)
                                    }
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
                        .scrollTargetLayout()
                    }
                    .scrollClipDisabled()
                    .scrollTargetBehavior(.viewAligned)
                    #endif
                } header: {
                    Text(section.section)
                        .font(.customFont(style: .body))
                        #if os(iOS)
                        .padding(.horizontal)
                        #endif
                        .padding(.bottom, 2)
                        #if !os(watchOS)
                        .listRowSeparator(.hidden)
                        .listSectionSeparator(.hidden)
                        #endif
                }
                #if !os(watchOS)
                .listRowInsets(.init())
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
                .listSectionSeparatorTint(Color.clear)
                .listRowSeparatorTint(Color.clear)
                .listRowBackground(Color.clear)
                #endif
            }
        }
        #if os(macOS)
        .listStyle(.plain)
        #elseif os(watchOS)
        .listStyle(.carousel)
        #else
        .listStyle(.grouped)
        #endif
        .navigationDestination(for: String.self) { link in
            if #available(iOS 18.0, macOS 15.0, visionOS 2.0, watchOS 11.0, *) {
                RouterView(link: link)
                    #if !os(macOS)
                    .navigationTransition(.zoom(sourceID: link, in: container))
                    #endif
            } else {
                RouterView(link: link)
            }
        }
    }
    
    @MainActor
    var emptyStateView: some View {
        Group {
            if !loading && exploreSections.isEmpty, let emptyState {
                EmptyStateView(
                    icon: emptyState.icon,
                    title: LocalizedStringKey(emptyState.title),
                    description: LocalizedStringKey(emptyState.subtitle),
                    showAction: emptyState.showAction,
                    actionTitle: "Try again"
                ) {
                    if case EmptyState.network = emptyState {
                        Task {
                            await getExplore()
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
