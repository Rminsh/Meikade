//
//  PoemView.swift
//  Meikade
//
//  Created by Armin on 12/22/23.
//

import SwiftUI

enum PoemType {
    case poem(id: Int)
    case random(poetID: Int? = nil)
}

struct PoemView: View {
    
    var poemType: PoemType? = nil
    
    @State var title: String = ""
    @State var subtitle: String = ""
    @State var verses: [Verse] = []
    @State var description: String = ""
    
    @State var loading: Bool = false
    @State var emptyState: EmptyState? = nil
    
    @State var showVersesTheme: Bool = false
    
    @AppStorage("versesFont") var versesFont: String = Fonts.vazirmatn.rawValue
    
    var shareText: String {
        if !verses.isEmpty {
            let allVerses: [String] = verses.map({$0.text ?? ""})
            let header: String = title + "\n" + subtitle + "\n\n"
            let result: String = allVerses.joined(separator: "\n")
            return header + result
        } else {
            return ""
        }
    }
    
    var isRTL: Bool {
        verses.first?.text?.isRTL ?? false
    }
    
    func getData() async {
        switch poemType {
        case .poem(let id):
            await getPoem(id: id)
        case .random:
            await getRandomPoem()
        default:
            if verses.isEmpty {
                emptyState = .poemEmpty
            }
        }
    }
    
    func getPoem(id: Int) async {
        loading = true
        let service = MeikadeService()
        do {
            let poem = try await service.getPoem(
                poemID: id,
                verseLimit: 200,
                verseOffset: 0
            )
            title = poem.poem.title
            subtitle = poem.poet.name
            verses = poem.verses
            description = poem.poem.phrase ?? ""
            
            if poem.verses.isEmpty {
                emptyState = .poemEmpty
            }
        } catch {
            emptyState = .network(subtitle: error.localizedDescription)
            #if DEBUG
            print(error)
            #endif
        }
        loading = false
    }
    
    func getRandomPoem() async {
        loading = true
        let service = MeikadeService()
        do {
            let poem = try await service.getRandomPoem(
                verseLimit: 200,
                verseOffset: 0
            )
            
            title = poem.poem.title
            subtitle = poem.poet.name
            verses = poem.verses
            description = poem.poem.phrase ?? ""
            
            if poem.verses.isEmpty {
                emptyState = .poemEmpty
            }
        } catch {
            emptyState = .network(subtitle: error.localizedDescription)
            #if DEBUG
            print(error)
            #endif
        }
        loading = false
    }
    
    func getPosition(_ position: Int) -> Alignment {
        switch position {
        case 0:
            return .leading
        case 1:
            return .trailing
        case 2:
            return .center
        case -5:
            return .leading
        default:
            return .leading
        }
    }
}

extension PoemView {
    var body: some View {
        content
            .overlay {
                emptyStateView
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
            .navigationTitle(title)
            #if os(macOS)
            .navigationSubtitle(subtitle)
            .environment(\.locale, .init(identifier: "fa"))
            .environment(\.layoutDirection, .rightToLeft)
            #elseif os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .task {
                await getData()
            }
    }
    
    var content: some View {
        List {
            ForEach(verses, id: \.id) { verse in
                if let verseText = verse.text {
                    Text(verseText)
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
                            alignment: getPosition(verse.position)
                        )
                        .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init())
                        .frame(maxWidth: 650)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                }
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
    
    var emptyStateView: some View {
        Group {
            if !loading && verses.isEmpty, let emptyState {
                EmptyStateView(
                    icon: emptyState.icon,
                    title: LocalizedStringKey(emptyState.title),
                    description: LocalizedStringKey(emptyState.subtitle),
                    showAction: emptyState.showAction,
                    actionTitle: "Try again"
                ) {
                    Task {
                        await getData()
                    }
                }
            } else if loading {
                ProgressView()
            }
        }
    }
}

extension EmptyState {
    static let poemEmpty = EmptyState.empty(icon: "text.book.closed", title: "Poem not found")
}

#Preview {
    NavigationStack {
        PoemView(
            title: "غزل شماره ۷۱",
            subtitle: "حافظ",
            verses: Verse.preview,
            description: "از سخن یاوه گویان ناراحت نشو تو همان راه راست را برو چون به نتیجه ی کارت اعتقاد داری. از استهزائ حریفان و ب خردان ناراحت نشو چون یکرنگ هستی و کبر و غرور هم نداری. در بارگاه حق تعالی مورد عنایت قرار می گیری.روی حمایت و دلسوزی بستگان هم حساب نکن."
        )
    }
    .environment(\.layoutDirection, .rightToLeft)
}
