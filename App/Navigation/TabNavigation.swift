//
//  TabNavigation.swift
//  Meikade
//
//  Created by Armin on 1/8/24.
//

import SwiftUI

struct TabNavigation: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        TabView {
            ForEach(Panel.allCases, id: \.self) { item in
                let menuText = Text(item.title)
                item.view()
                    .navigationTitle(item.title)
                    .tabItem {
                        Label(item.title, systemImage: item.icon)
                            .accessibility(label: menuText)
                    }
                    .tag(item.hashValue)
            }
        }
    }
}

#Preview {
    TabNavigation()
}
