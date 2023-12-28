//
//  PoetsListView.swift
//  Meikade
//
//  Created by Armin on 12/27/23.
//

import NukeUI
import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

struct PoetsListView {
    @State var types: [PoetType] = []
    @State var selectedType: Int? = nil
    
    @State var poets: [PoetItem] = []
    
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
                if let poetID = poet.poetID {
                    NavigationLink {
                        PoetView(poetID: poetID)
                    } label: {
                        HStack {
                            if selectedType != 4 {
                                LazyImage(url: URL(string: "https://meikade.com/offlines/thumbs/\(poetID).png")) { state in
                                    if let image = state.image {
                                        image
                                            .resizable()
                                    } else {
                                        Rectangle()
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 48, height: 48)
                                .clipShape(.circle)
                                .shadow(radius: 1)
                            }
                            
                            Text(poet.title)
                                .customFont(style: .title3)
                                .padding(5)
                        }
                    }
                }
            }
        }
        #if os(macOS)
        .listStyle(.inset(alternatesRowBackgrounds: true))
        .environment(\.defaultMinListRowHeight, 60)
        #endif
        .overlay {
            emptyStateView
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                poetTypes
            }
        }
        .task {
            await loadAll()
        }
        .toolbarTitleDisplayMode(.inline)
        .navigationTitle("Poets")
        .environment(\.locale, .init(identifier: "fa"))
        .environment(\.layoutDirection, .rightToLeft)
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
    .environment(\.locale, .init(identifier: "fa"))
    .environment(\.layoutDirection, .rightToLeft)
}
