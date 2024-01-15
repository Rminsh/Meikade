//
//  VersesThemeView.swift
//  Meikade
//
//  Created by Armin on 12/25/23.
//

import SwiftUI

struct VersesThemeView {
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("versesFont") var versesFont: String = Fonts.vazirmatn.rawValue
    
    #if os(macOS)
    let columns = [
        GridItem(.flexible(minimum: 84)),
        GridItem(.flexible(minimum: 84)),
        GridItem(.flexible(minimum: 84))
    ]
    #else
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    #endif
}

extension VersesThemeView: View {
    
    var body: some View {
        NavigationStack {
            content
                .toolbar {
                    ToolbarItem {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Label("Close", systemImage: "xmark.circle.fill")
                                .font(.title3)
                        }
                        .foregroundStyle(.secondary)
                        .symbolRenderingMode(.hierarchical)
                        .buttonStyle(.borderless)
                    }
                }
        }
    }
    
    var content: some View {
        LazyVGrid(columns: columns) {
            ForEach(Fonts.allCases, id:\.hashValue) { font in
                Button {
                    versesFont = font.rawValue
                } label: {
                    Text("Font / قلم")
                        #if os(iOS)
                        .padding()
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        #else
                        .padding(4)
                        #endif
                        .customFont(
                            name: Fonts(rawValue: font.rawValue) ?? .vazirmatn,
                            style: .subheadline
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                }
                .overlay {
                    #if os(iOS)
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(.accent, lineWidth: versesFont == font.rawValue ? 2 : 0)
                    #else
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: versesFont == font.rawValue ? 2 : 0)
                    #endif
                }
                #if os(macOS)
                .background(Color(nsColor: .controlBackgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .buttonStyle(.plain)
                #else
                .buttonStyle(.bordered)
                #endif
                #if os(visionOS)
                .buttonBorderShape(.roundedRectangle(radius: 8))
                #endif
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        PoemView(verses: Verse.preview, showVersesTheme: true)
    }
}
