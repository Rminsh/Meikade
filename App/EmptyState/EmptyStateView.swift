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
        Group {
            if #available(iOS 17.0, macOS 14.0, visionOS 1.0, *) {
                ContentUnavailableView {
                    Label(title, systemImage: icon)
                        .font(.customFont(style: .largeTitle))
                } description: {
                    Text(description)
                        .font(.customFont(style: .headline))
                } actions: {
                    if let actionTitle, let action, showAction {
                        Button(action: action) {
                            Text(actionTitle)
                                .font(.customFont(style: .body))
                        }
                    }
                }
            } else {
                backwardView
            }
        }
    }
    
    var backwardView: some View {
        VStack {
            Image(systemName: icon)
                #if os(iOS)
                .font(.largeTitle)
                .dynamicTypeSize(.accessibility2)
                .foregroundStyle(.secondary)
                #else
                .font(.system(size: 36))
                .foregroundStyle(.tertiary)
                #endif
                
            
            Text(title)
                .font(.customFont(style: .largeTitle))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.all, 12)
                #if os(iOS)
                .foregroundStyle(.primary)
                #else
                .foregroundStyle(.secondary)
                #endif
            
            Text(description)
                .font(.customFont(style: .headline))
                .foregroundStyle(.secondary)
            
            if let actionTitle, let action, showAction {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.customFont(style: .body))
                }
                .padding(.top, 6)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    EmptyStateView(
        icon: "person.bust",
        title: "Poet not found",
        description: "Poet not found"
    )
}
