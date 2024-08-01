//
//  PoetsListView.swift
//  Meikade
//
//  Created by Armin on 12/27/23.
//

import NukeUI
import SwiftUI

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
        poets.removeAll()
        loading = true
        let service = MeikadeService()
        do {
            poets = try await service.getPoets(
                limit: 100,
                offset: 0,
                typeID: selectedType ?? 0
            ).sorted {
                $0.title.localizedStandardCompare($1.title) == .orderedAscending
            }
            
            if poets.isEmpty {
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
                                .pipeline(.init(configuration: .withDataCache))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 42, height: 42)
                                .clipShape(.circle)
                                .shadow(radius: 1)
                            }
                            
                            Text(poet.title)
                                #if os(watchOS)
                                .font(.customFont(style: .caption1))
                                #else
                                .font(.customFont(style: .body))
                                #endif
                        }
                    }
                    #if !os(watchOS)
                    .listRowInsets(.init(top: 6, leading: 16, bottom: 6, trailing: 16))
                    #endif
                }
            }
        }
        #if os(watchOS)
        .listStyle(.carousel)
        #endif
        #if os(macOS)
        .navigationTitle("")
        .listStyle(.inset(alternatesRowBackgrounds: true))
        .environment(\.defaultMinListRowHeight, 60)
        #else
        .navigationTitle("Poets")
        #endif
        #if os(iOS)
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .overlay {
            emptyStateView
        }
        .toolbar {
            #if os(watchOS)
            ToolbarItem {
                poetTypes
            }
            #else
            ToolbarItem(placement: .principal) {
                poetTypes
            }
            #endif
        }
        .task {
            if poets.isEmpty {
                await loadAll()
            }
        }
    }
    
    @MainActor
    var poetTypes: some View {
        Picker(selection: $selectedType) {
            ForEach(types, id: \.id) { type in
                Text(LocalizedStringKey(type.nameEN))
                    .font(.customFont(style: .body))
                    .tag(type.id)
                    #if os(watchOS)
                    .frame(maxWidth: .infinity)
                    #endif
            }
        } label: {
            Label("Poet Types", systemImage: "person.bust")
                .font(.customFont(style: .body))
                #if os(watchOS)
                .frame(maxWidth: .infinity)
                #endif
        }
        #if os(watchOS)
        .pickerStyle(.navigationLink)
        #else
        .pickerStyle(.segmented)
        #endif
        #if os(visionOS) || os(watchOS)
        .onChange(of: selectedType) {
            Task {
                await getPoets()
            }
        }
        #else
        .onChange(of: selectedType) { _ in
            Task {
                await getPoets()
            }
        }
        #endif
    }
    
    @MainActor
    var emptyStateView: some View {
        Group {
            if !loading && poets.isEmpty , let emptyState {
                EmptyStateView(
                    icon: emptyState.icon,
                    title: LocalizedStringKey(emptyState.title),
                    description: LocalizedStringKey(emptyState.subtitle),
                    showAction: emptyState.showAction,
                    actionTitle: "Try again"
                ) {
                    if case EmptyState.network = emptyState {
                        Task {
                            await loadAll()
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
