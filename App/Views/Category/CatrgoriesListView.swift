//
//  CatrgoriesListView.swift
//  Meikade
//
//  Created by Armin on 12/29/23.
//

import SwiftUI

struct CatrgoriesListView {
    var poetID: Int
    var categoryID: Int
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
                emptyState = .empty(
                    icon: "books.vertical",
                    title: "List is empty"
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

extension CatrgoriesListView: View {
    var body: some View {
        Form {
            ForEach(categories, id: \.self) { category in
                NavigationLink {
                    RouterView(link: category.link)
                } label: {
                    Text(category.title)
                        .customFont(style: .body)
                }
            }
        }
        #if os(macOS)
        .navigationTitle("")
        .environment(\.locale, .init(identifier: "fa"))
        .environment(\.layoutDirection, .rightToLeft)
        #else
        .navigationTitle(title)
        #endif
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(emptyStateView)
        .formStyle(.grouped)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(title)
                    .customFont(style: .title3, weight: .bold)
            }
        }
        .task {
            await getPoems()
        }
    }
    
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
        #if os(macOS)
        .frame(width: 450, height: 450)
        #else
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}