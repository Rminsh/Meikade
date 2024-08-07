//
//  PoemView.swift
//  Meikade
//
//  Created by Armin on 12/22/23.
//

import SwiftUI

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
    
    var selectedFont: Fonts {
        Fonts.getValue(name: versesFont) ?? .vazirmatn
    }
    
    var attributedVerses: NSAttributedString {
        let result = NSMutableAttributedString()
        for verse in verses {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = verse.nsPosition
            paragraphStyle.paragraphSpacing = 8
            
            #if os(iOS)
            let font = UXFont.custom(name: selectedFont, style: .body)
            #else
            let font = UXFont.custom(name: selectedFont, style: .title3)
            #endif
            
            let verseAttributedString = NSAttributedString(
                string: verse.text ?? "",
                attributes: [
                    .font: font,
                    .foregroundColor: UXColor.label,
                    .paragraphStyle: paragraphStyle,
                ]
            )
            result.append(verseAttributedString)
            result.append(NSAttributedString(string: "\n"))
        }
        
        return result
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
        DispatchQueue.main.async {
            loading = true
        }
        
        let service = MeikadeService()
        do {
            let poem = try await service.getPoem(
                poemID: id,
                verseLimit: 200,
                verseOffset: 0
            )
            
            DispatchQueue.main.async {
                title = poem.poem.title
                subtitle = poem.poet.name
                verses = poem.verses
                description = poem.poem.phrase ?? ""
                
                if poem.verses.isEmpty {
                    emptyState = .poemEmpty
                }
            }
        } catch {
            emptyState = .network(subtitle: error.localizedDescription)
            #if DEBUG
            print(error)
            #endif
        }
        DispatchQueue.main.async {
            loading = false
        }
    }
    
    func getRandomPoem() async {
        DispatchQueue.main.async {
            loading = true
        }
        
        let service = MeikadeService()
        do {
            let poem = try await service.getRandomPoem(
                verseLimit: 200,
                verseOffset: 0
            )
            
            DispatchQueue.main.async {
                title = poem.poem.title
                subtitle = poem.poet.name
                verses = poem.verses
                description = poem.poem.phrase ?? ""
                
                if poem.verses.isEmpty {
                    emptyState = .poemEmpty
                }
            }
        } catch {
            emptyState = .network(subtitle: error.localizedDescription)
            #if DEBUG
            print(error)
            #endif
        }
        
        DispatchQueue.main.async {
            loading = false
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
                        ShareLink(item: shareText) {
                            Label("Share", systemImage: "square.and.arrow.up")
                                .font(.customFont(style: .body))
                        }
                    }
                }
                #if os(watchOS)
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {showVersesTheme.toggle()}) {
                        Label("Theme", systemImage: "textformat.alt")
                            .font(.customFont(style: .body))
                    }
                    .sheet(isPresented: $showVersesTheme) {
                        VersesThemeView()
                    }
                }
                #else
                ToolbarItem {
                    Button(action: {showVersesTheme.toggle()}) {
                        Label("Theme", systemImage: "textformat.alt")
                    }
                    .popover(isPresented: $showVersesTheme) {
                        VersesThemeView()
                            .presentationDetents([.fraction(0.35), .medium])
                    }
                }
                #endif
                
                #if os(iOS)
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(subtitle)
                            .font(.customFont(style: .subheadline))
                        
                        Text(title)
                            .font(.customFont(style: .headline, weight: .bold))
                    }
                }
                #elseif os(visionOS)
                ToolbarItem(placement: .principal) {
                    VStack(alignment: .leading) {
                        Text(subtitle)
                            .font(.customFont(style: .subheadline))
                        
                        Text(title)
                            .font(.customFont(style: .headline, weight: .bold))
                    }
                }
                #endif
            }
            .navigationTitle(title)
            #if os(macOS)
            .navigationSubtitle(subtitle)
            #elseif os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .task {
                await getData()
            }
    }
    
    var content: some View {
        List {
            poemVerses
            poemDescription
        }
        #if os(watchOS)
        .listStyle(.elliptical)
        #else
        .listStyle(.plain)
        #endif
    }
    
    var poemVerses: some View {
        Group {
            #if os(macOS) || os(watchOS)
            Group {
                ForEach(verses, id: \.id) { verse in
                    if let verseText = verse.text {
                        Group {
                            Text(selectedFont.surroundedCharacter) +
                            Text(verseText) +
                            Text(selectedFont.surroundedCharacter)
                        }
                        .frame(
                            maxWidth: .infinity,
                            alignment: verse.alignment
                        )
                    }
                }
            }
            .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
            #if os(watchOS)
            .font(.customFont(name: selectedFont, style: .body))
            #else
            .textSelection(.enabled)
            .font(.customFont(name: selectedFont, style: .title3))
            .frame(maxWidth: 650)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.vertical, 5)
            #endif
            #else
            RichText(attributedVerses)
                .frame(maxWidth: 650)
                .frame(maxWidth: .infinity)
            #endif
        }
        #if os(watchOS)
        .listItemTint(.clear)
        #else
        .listRowSeparator(.hidden)
        #endif
        .listRowInsets(.init())
    }
    
    var poemDescription: some View {
        Group {
            if description != "" {
                Section {
                    Text(description)
                        .font(.customFont(style: .body))
                        .frame(maxWidth: 650)
                        .frame(maxWidth: .infinity)
                } header: {
                    Text("Phrase")
                        .font(.customFont(style: .body))
                }
                #if !os(watchOS)
                .listSectionSeparator(.hidden, edges: .bottom)
                .padding(.horizontal)
                #endif
            }
        }
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
