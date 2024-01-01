//
//  PoemsListView.swift
//  Meikade
//
//  Created by Armin on 12/29/23.
//

import SwiftUI

struct PoemsListView {
    var poetID: Int
    var categoryID: Int
    var title: String = ""
    
    @State var poems: [PoemDetail] = []
    
    @State var loading: Bool = false
    @State var emptyState: EmptyState? = nil
    
    func getPoems() async {
        loading = true
        
        let service = MeikadeService()
        do {
            poems = try await service.getPoems(
                poetID: poetID,
                categoryID: categoryID,
                offset: 0
            )
            
            if poems.isEmpty {
                emptyState = .empty(
                    icon: "books.vertical",
                    title: "Poems list is empty"
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

extension PoemsListView: View {
    var body: some View {
        Form {
            ForEach(poems, id: \.id) { poem in
                NavigationLink {
                    PoemView(poemType: .poem(id: poem.id))
                } label: {
                    Text(poem.title)
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
            if !loading && poems.isEmpty, let emptyState {
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
        PoemsListView(
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
