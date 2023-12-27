//
//  PoetsListView.swift
//  Meikade
//
//  Created by Armin on 12/27/23.
//

import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

struct PoetsListView {
    @State var types: [PoetType] = []
    @State var selectedType: Int? = nil
    
    @State var poets: [Poet] = []
    
    @State var loading: Bool = false
    @State var emptyState: EmptyState? = nil
    
    func getTypes() async {
        loading = true
        let service = MeikadeService()
        do {
            types = try await service.getPoetTypes()
            selectedType = types.first?.id
        } catch {
            emptyState = .network(subtitle: error.localizedDescription)
            #if DEBUG
            print(error)
            #endif
        }
        loading = false
    }
    
    func getPoets() async {
        loading = true
        let service = MeikadeService()
        do {
            poets = try await service.getPoets(
                limit: 100,
                offset: 0,
                typeID: selectedType ?? 0
            )
            
            if poets.isEmpty {
                emptyState = .empty(
                    icon: "person.bust",
                    title: "Nobody found"
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
    
    func loadAll() async {
        await getTypes()
        await getPoets()
    }
}
    
extension PoetsListView: View {
    var body: some View {
        List {
            ForEach(poets, id: \.self) { poet in
                Text(poet.title ?? "")
                    .customFont(style: .title3)
                    .padding(.vertical, 5)
            }
        }
        .overlay {
            emptyStateView
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                poetTypes
            }
        }
        .task {
            await loadAll()
        }
        .navigationTitle("Poets")
    }
    
    var poetTypes: some View {
        Picker("Types", selection: $selectedType) {
            ForEach(types, id: \.id) { type in
                Text(LocalizedStringKey(type.nameEN))
                    .customFont(style: .body)
                    .tag(type.id)
            }
        }
        .pickerStyle(.segmented)
        #if os(iOS) || os(visionOS)
        .introspect(
            .picker(style: .segmented),
            on: .iOS(.v16...), .visionOS(.v1...)
        ) { item in
            let font = UXFont.custom(style: .caption1)
            item.setTitleTextAttributes(
                [NSAttributedString.Key.font: font],
                for: .normal
            )
        }
        #elseif os(macOS)
        .introspect(.picker(style: .segmented), on: .macOS(.v13...)) { item in
            item.font = UXFont.custom(style: .body)
        }
        #endif
        .onChange(of: selectedType) {
            Task {
                await getPoets()
            }
        }
    }
    
    var emptyStateView: some View {
        Group {
            if !loading && poets.isEmpty , let emptyState {
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
                                await loadAll()
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
    NavigationStack {
        PoetsListView()
    }
}
