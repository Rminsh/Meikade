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
    @State var description: String = ""
    
    @State var loading: Bool = false
    @State var emptyState: PoemEmptyState? = nil
    
    @State var showVersesTheme: Bool = false
    
    @AppStorage("versesFont") var versesFont: String = Fonts.vazirmatn.rawValue
    
    var shareText: String {
        if !verses.isEmpty {
            let allVerses: [String] = verses.map({$0.text})
            let header: String = title + "\n" + subtitle + "\n\n"
            let result: String = allVerses.joined(separator: "\n")
            return header + result
        } else {
            return ""
        }
    }
    
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
                description = poem.poem.phrase ?? ""
                
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
                        if shareText != "" {
                            ShareLink(item: shareText)
                        }
                    }
                    ToolbarItem {
                        Button(action: {showVersesTheme.toggle()}) {
                            Label("Theme", systemImage: "textformat.alt")
                        }
                        .popover(isPresented: $showVersesTheme) {
                            VersesThemeView()
                                .presentationDetents([.fraction(0.2), .medium])
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
                    #if os(iOS)
                    .customFont(
                        name: Fonts.getValue(name: versesFont) ?? .vazirmatn,
                        style: .body
                    )
                    #else
                    .customFont(
                        name: Fonts.getValue(name: versesFont) ?? .vazirmatn,
                        style: .title3
                    )
                    #endif
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
                    .padding(.vertical, 5)
            }
            
            if description != "" {
                Section {
                    Text(description)
                        .customFont(style: .body)
                } header: {
                    Text("Phrase")
                        .customFont(style: .body)
                }
                .listSectionSeparator(.hidden, edges: .bottom)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    PoemView(
        title: "غزل شماره ۷۱",
        subtitle: "حافظ",
        verses: Verse.preview,
        description: "از سخن یاوه گویان ناراحت نشو تو همان راه راست را برو چون به نتیجه ی کارت اعتقاد داری. از استهزائ حریفان و ب خردان ناراحت نشو چون یکرنگ هستی و کبر و غرور هم نداری. در بارگاه حق تعالی مورد عنایت قرار می گیری.روی حمایت و دلسوزی بستگان هم حساب نکن."
    )
    .environment(\.layoutDirection, .rightToLeft)
}
