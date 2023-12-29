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
    
    func getPoet() async {
        let service = MeikadeService()
        do {
            poet = try await service.getPoet(poetID: poetID)
        } catch {
            
        }
    }
}

extension PoetView: View {
    var body: some View {
        List {
            if let poet {
                Section {
                    VStack {
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
                        .frame(width: 64, height: 64)
                        .clipShape(.circle)
                        .shadow(radius: 1)
                        
                        Text(poet.name)
                            .customFont(style: .title1, weight: .bold)
                    }
                    .frame(maxWidth: .infinity)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                
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
                } header: {
                    Text("Description")
                        .customFont(style: .subheadline)
                }
                
                if let categories = poet.categories {
                    Section {
                        ForEach(categories, id: \.id) { category in
                            NavigationLink {
                                PoemsListView(
                                    poetID: poetID,
                                    categoryID: category.id
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
        .navigationTitle("")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .task {
            await getPoet()
        }
    }
}

#Preview {
    NavigationStack {
        PoetView(poetID: 2)
    }
}
