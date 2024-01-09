//
//  TabNavigation.swift
//  Meikade
//
//  Created by Armin on 1/8/24.
//

#if !os(macOS)
import SwiftUI

struct TabNavigation: View {
    
    @State private var path = NavigationPath()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        TabView {
            ForEach(Panel.allCases, id: \.self) { item in
                let menuText = Text(item.title)
                NavigationStack(path: $path) {
                    item.view()
                        .navigationTitle(item.title)
                }
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
#endif
