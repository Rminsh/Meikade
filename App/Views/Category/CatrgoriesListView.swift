//
//  CatrgoriesListView.swift
//  Meikade
//
//  Created by Armin on 12/29/23.
//

import SwiftUI

struct CatrgoriesListView {
    let poetID: Int
    let categoryID: Int
    var title: String = ""
    
    @State var categories: [Category] = []
    
    @State var loading: Bool = false
    @State var emptyState: EmptyState? = nil
    
    func getPoems() async {
        loading = true
        
        let service = MeikadeService()
        do {
            categories = try await service.getCategories(
                poetID: poetID,
                parentID: categoryID
            )
            
            if categories.isEmpty {
                emptyState = .categoryEmpty
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

extension CatrgoriesListView: View {
    var body: some View {
        List {
            ForEach(categories, id: \.self) { category in
                NavigationLink {
                    RouterView(
                        link: category.link,
                        title: category.title
                    )
                } label: {
                    Text(category.title)
                        .font(.customFont(style: .body))
                }
            }
        }
        #if os(macOS)
        .navigationTitle("")
        .listStyle(.inset(alternatesRowBackgrounds: true))
        .environment(\.defaultMinListRowHeight, 32)
        #else
        .navigationTitle(title)
        #endif
        #if os(iOS)
        .listStyle(.plain)
        #endif
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(emptyStateView)
        #if !os(watchOS)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(title)
                    .font(.customFont(style: .title3, weight: .bold))
            }
        }
        #endif
        .task {
            if categories.isEmpty {
                await getPoems()
            }
        }
    }
    
    @MainActor
    var emptyStateView: some View {
        Group {
            if !loading && categories.isEmpty, let emptyState {
                EmptyStateView(
                    icon: emptyState.icon,
                    title: LocalizedStringKey(emptyState.title),
                    description: LocalizedStringKey(emptyState.subtitle),
                    showAction: emptyState.showAction,
                    actionTitle: "Try again"
                ) {
                    if case EmptyState.network = emptyState {
                        Task {
                            await getPoems()
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
        CatrgoriesListView(
            poetID: 2,
            categoryID: 24,
            title: "غزلیات"
        )
    }
}
