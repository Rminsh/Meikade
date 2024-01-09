//
//  Panel.swift
//  Meikade
//
//  Created by Armin on 1/8/24.
//

import SwiftUI

enum Panel: CaseIterable {
    case explore
    case poets
    case hafezDivination
}

extension Panel {
    var title: LocalizedStringKey {
        switch self {
        case .explore:
            return "Explore"
        case .poets:
            return "Poets"
        case .hafezDivination:
            return "Hafez Divination"
        }
    }
    
    var icon: String {
        switch self {
        case .explore:
            return "star.square.on.square"
        case .poets:
            return "person.bust"
        case .hafezDivination:
            return "text.book.closed"
        }
    }
    
    @ViewBuilder func view() -> some View {
        switch self {
        case .explore:
            ExploreView()
        case .poets:
            PoetsListView()
        case .hafezDivination:
            HafezFaalView()
        }
    }
}
