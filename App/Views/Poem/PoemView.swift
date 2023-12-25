//
//  PoemView.swift
//  Meikade
//
//  Created by Armin on 12/22/23.
//

import SwiftUI

struct PoemView: View {
    
    var poemID: Int? = nil
    
    @State var title: String = ""
    @State var subtitle: String = ""
    @State var verses: [Verse] = []
    
    @State var loading: Bool = false
    @State var emptyState: PoemEmptyState? = nil
    
    @State var showVersesTheme: Bool = false
    
    @AppStorage("versesFont") var versesFont: String = Fonts.dimaShekasteh.rawValue
    
    var isRTL: Bool {
        verses.first?.text.isRTL ?? false
    }
    
    enum PoemEmptyState: Equatable {
        case empty
        case network(subtitle: String)
        
        var icon: String {
            switch self {
            case .empty:
                return "text.book.closed"
            case .network:
                return "wifi.exclamationmark"
            }
        }
        
        var title: String {
            switch self {
            case .empty:
                return "Poem not found"
            case .network:
                return "Connection error"
            }
        }
        
        var subtitle: String {
            switch self {
            case .empty:
                return ""
            case .network(let subtitle):
                return subtitle
            }
        }
    }
    
    func getPoem() async {
        if let poemID {
            loading = true
            let service = MeikadeService()
            do {
                let poem = try await service.getPoem(
                    poemID: poemID,
                    verseLimit: 200,
                    verseOffset: 0
                )
                title = poem.poem.title
                subtitle = poem.poet.name
                verses = poem.verses
                
                if poem.verses.isEmpty {
                    emptyState = .empty
                }
            } catch {
                emptyState = .network(subtitle: error.localizedDescription)
                #if DEBUG
                print(error)
                #endif
            }
            loading = false
        } else {
            if verses.isEmpty {
                emptyState = .empty
            }
        }
    }
}

extension PoemView {
    var body: some View {
        NavigationStack {
            content
                .overlay {
                    if !loading && verses.isEmpty, let emptyState {
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
                            if emptyState != .empty {
                                Button {
                                    Task {
                                        await getPoem()
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
                .toolbar {
                    ToolbarItem {
                        Button(action: {showVersesTheme.toggle()}) {
                            Label("Theme", systemImage: "textformat.alt")
                        }
                        .popover(isPresented: $showVersesTheme) {
                            VersesThemeView()
                        }
                    }
                    
                    #if os(iOS)
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text(subtitle)
                                .customFont(style: .subheadline)
                            
                            Text(title)
                                .customFont(style: .headline, weight: .bold)
                        }
                    }
                    #elseif os(visionOS)
                    ToolbarItem(placement: .principal) {
                        VStack(alignment: .leading) {
                            Text(subtitle)
                                .customFont(style: .subheadline)
                            
                            Text(title)
                                .customFont(style: .headline, weight: .bold)
                        }
                    }
                    #endif
                }
                #if os(macOS)
                .navigationTitle(title)
                .navigationSubtitle(subtitle)
                #elseif os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
        }
        .task {
            await getPoem()
        }
    }
    
    var content: some View {
        List {
            ForEach(verses, id: \.id) { verse in
                Text(verse.text)
                    .textSelection(.enabled)
                    .customFont(
                        name: Fonts.getValue(name: versesFont) ?? .vazirmatn,
                        style: .body
                    )
                    .frame(
                        maxWidth: .infinity,
                        alignment: verse.position == 0 ? .leading : .trailing
                    )
                    .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init())
                    .frame(maxWidth: 650)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    PoemView(
        title: "غزل شماره ۷۱",
        subtitle: "حافظ",
        verses: Verse.preview
    )
}
