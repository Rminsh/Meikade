//
//  PoetView.swift
//  Meikade
//
//  Created by Armin on 12/28/23.
//

import NukeUI
import SwiftUI

struct PoetView {
    var poetID: Int
    
    @State var poet: Poet? = nil
    @State var categories: [Category] = []
    @State var descriptionExpanded: Bool = false
    
    @State var loading: Bool = false
    @State var emptyState: EmptyState? = nil
    
    func getPoet() async {
        loading = true
        
        let service = MeikadeService()
        do {
            let poetResult = try await service.getPoet(poetID: poetID)
            if poetResult.username != "" && poetResult.name != "" {
                poet = poetResult
                await getCategories()
            } else {
                emptyState = .poetEmpty
            }
        } catch {
            emptyState = .network(subtitle: error.localizedDescription)
            #if DEBUG
            print(error)
            #endif
        }
        
        loading = false
    }
    
    func getCategories() async {
        loading = true
        
        let service = MeikadeService()
        do {
            let result = try await service.getCategories(poetID: poetID, parentID: nil)
            if !result.isEmpty {
                categories = result
            } else {
                emptyState = .poetEmpty
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

extension PoetView: View {
    var body: some View {
        Form {
            if let poet {
                Section {
                    Group {
                        if poet.description != "" && poet.description != "null" {
                            VStack(spacing: 5) {
                                Text(poet.description)
                                    #if os(watchOS)
                                    .font(.customFont(style: .callout))
                                    .lineLimit(descriptionExpanded ? nil : 2)
                                    #else
                                    .font(.customFont(style: .body))
                                    .lineLimit(descriptionExpanded ? nil : 3)
                                    #endif
                                    .environment(\.layoutDirection, poet.description.isRTL ? .rightToLeft : .leftToRight)
                                
                                Button {
                                    withAnimation {
                                        descriptionExpanded.toggle()
                                    }
                                } label: {
                                    Label(
                                        descriptionExpanded ? "Less" : "More",
                                        systemImage: descriptionExpanded ? "chevron.up" : "chevron.down"
                                    )
                                    .labelStyle(.iconOnly)
                                    .font(.customFont(style: .caption1))
                                }
                            }
                        }
                    }
                    #if !os(watchOS)
                    .listRowSeparator(.hidden, edges: .bottom)
                    #endif
                } header: {
                    VStack {
                        LazyImage(url: URL(string: "https://meikade.com/offlines/thumbs/\(poetID).png")) { state in
                            if let image = state.image {
                                image
                                    .resizable()
                            } else {
                                Circle()
                                    .foregroundStyle(.accent.gradient)
                                    .overlay {
                                        Image(systemName: "person.bust.fill")
                                            .font(.largeTitle)
                                            .foregroundStyle(.white)
                                    }
                            }
                        }
                        .pipeline(.init(configuration: .withDataCache))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 64, height: 64)
                        .clipShape(.circle)
                        .shadow(radius: 1)
                        
                        Text(poet.name)
                            #if os(watchOS)
                            .font(.customFont(style: .title3, weight: .bold))
                            .padding(.bottom, 5)
                            #else
                            .font(.customFont(style: .title1, weight: .bold))
                            #endif
                    }
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                }
                
                Section {
                    ForEach(categories, id: \.self) { category in
                        if !category.isUnlisted {
                            NavigationLink {
                                RouterView(
                                    link: category.link,
                                    title: category.title
                                )
                            } label: {
                                Text(category.title)
                                    .font(.customFont(style: .body))
                                    .padding(2)
                            }
                        }
                    }
                }
            }
        }
        .formStyle(.grouped)
        #if os(iOS) || os(watchOS)
        .navigationTitle(poet?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        #elseif os(macOS)
        .navigationTitle("")
        .frame(maxWidth: 650)
        .scrollIndicators(.hidden)
        #endif
        .overlay {
            emptyStateView
        }
        .task {
            if poet == nil || categories.isEmpty {
                await getPoet()
            }
        }
    }
    
    @MainActor
    var emptyStateView: some View {
        Group {
            if !loading && poet == nil, let emptyState {
                EmptyStateView(
                    icon: emptyState.icon,
                    title: LocalizedStringKey(emptyState.title),
                    description: LocalizedStringKey(emptyState.subtitle),
                    showAction: emptyState.showAction,
                    actionTitle: "Try again"
                ) {
                    if case EmptyState.network = emptyState {
                        Task {
                            await getPoet()
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
    NavigationStack {
        PoetView(poetID: 2)
            #if os(macOS)
            .frame(width: 450, height: 450)
            #endif
    }
}
