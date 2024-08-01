//
//  EmptyStateView.swift
//  Meikade
//
//  Created by Armin on 12/31/23.
//

import SwiftUI

struct EmptyStateView: View {
    
    var icon: String
    var title: LocalizedStringKey
    var description: LocalizedStringKey
    
    var showAction: Bool = true
    var actionTitle: LocalizedStringKey? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: icon)
                #if os(watchOS)
                .font(.customFont(style: .title3))
                #else
                .font(.customFont(style: .largeTitle))
                #endif
        } description: {
            Text(description)
                #if os(watchOS)
                .font(.customFont(style: .body))
                #else
                .font(.customFont(style: .headline))
                #endif
        } actions: {
            if let actionTitle, let action, showAction {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.customFont(style: .body))
                        #if os(watchOS)
                        .padding(.horizontal)
                        #endif
                }
                #if os(watchOS)
                .tint(.accentColor)
                .buttonStyle(.bordered)
                #endif
            }
        }
    }
}

#Preview {
    EmptyStateView(
        icon: "person.bust",
        title: "Poet not found",
        description: "Poet not found",
        actionTitle: "Try again",
        action: { print("Hello, World!") }
    )
}
