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
            } else {
                emptyState = .empty(
                    icon: "person.bust",
                    title: "Poet not found"
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

extension PoetView: View {
    var body: some View {
        Form {
            if let poet {
                Section {
                    VStack(spacing: 5) {
                        Text(poet.description)
                            .customFont(style: .body)
                            .lineLimit(descriptionExpanded ? nil : 3)
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
                            .customFont(style: .caption1)
                        }
                    }
                    .listRowSeparator(.hidden, edges: .bottom)
                } header: {
                    VStack {
                        LazyImage(url: URL(string: "https://meikade.com/offlines/thumbs/\(poetID).png")) { state in
                            if let image = state.image {
                                image
                                    .resizable()
                            } else {
                                Circle()
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 64, height: 64)
                        .clipShape(.circle)
                        .shadow(radius: 1)
                        
                        Text(poet.name)
                            .customFont(style: .title1, weight: .bold)
                    }
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                }
                
                if let categories = poet.categories {
                    Section {
                        ForEach(categories, id: \.id) { category in
                            NavigationLink {
                                PoemsListView(
                                    poetID: poetID,
                                    categoryID: category.id,
                                    title: category.title
                                )
                            } label: {
                                Text(category.title)
                                    .customFont(style: .body)
                                    .padding(2)
                            }
                        }
                    }
                }
            }
        }
        .formStyle(.grouped)
        #if os(iOS)
        .navigationTitle(poet?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        #elseif os(macOS)
        .navigationTitle("")
        .environment(\.locale, .init(identifier: "fa"))
        .environment(\.layoutDirection, .rightToLeft)
        #endif
        .overlay {
            emptyStateView
        }
        .task {
            await getPoet()
        }
    }
    
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
