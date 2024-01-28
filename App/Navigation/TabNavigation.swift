//
//  TabNavigation.swift
//  Meikade
//
//  Created by Armin on 1/8/24.
//

#if !os(macOS)
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
            .environment(\.layoutDirection, .rightToLeft)
        }
        
        .environment(\.locale, .init(identifier: "fa"))
        #if os(iOS)
        .environment(\.layoutDirection, .rightToLeft)
        #endif
        /// Note:
        /// There is a bug with Floating Tabbar for visionOS with RTL that overlay on current window instead of a fixed position relative to the window, so we moved layoutDirection envrionment object here instead of using it in MainView. Also this bug is presented in macOS 14 that sidebar is in the left section instead of right. These issues should be addressed in the next Xcode versions (Currently presents in Xcode 15.2)
    }
}

#Preview {
    TabNavigation()
}
#endif
