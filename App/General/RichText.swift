//
//  RichText.swift
//  Meikade
//
//  Created by Armin on 1/11/24.
//

#if !os(watchOS)
import SwiftUI
import RichTextKit

struct RichText: UXViewRepresentable {
    var attributedText: NSAttributedString
    
    init(_ attributedText: NSAttributedString) {
        self.attributedText = attributedText
    }
    
    #if os(macOS)
    func makeNSView(context: Context) -> RichTextView {
        let label = RichTextView()
        label.setRichText(attributedText)
        label.textContentInset = .init(width: 20, height: 8)
        label.isEditable = false
        label.backgroundColor = .clear
        
        return label
    }
    
    func updateNSView(_ nsView: RichTextView, context: Context) {
        nsView.setRichText(attributedText)
    }
    #else
    func makeUIView(context: Context) -> RichTextView {
        let label = RichTextView(string: attributedText)
        label.isEditable = false
        label.textContainerInset = .init(top: 8, left: 20, bottom: 8, right: 20)
        label.isScrollEnabled = false
        return label
    }
    
    func updateUIView(_ uiView: RichTextView, context: Context) {
        uiView.attributedText = attributedText
    }
    #endif
}

#Preview {
    RichText(NSAttributedString("Hello world"))
}
#endif
