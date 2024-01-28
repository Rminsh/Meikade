//
//  MainView.swift
//  Meikade
//
//  Created by Armin on 1/8/24.
//

import SwiftUI

struct MainView: View {
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    var body: some View {
        ZStack {
            #if os(visionOS)
            TabNavigation()
            #elseif os(iOS)
            if horizontalSizeClass == .compact {
                TabNavigation()
            } else {
                Sidebar()
                    .environment(\.locale, .init(identifier: "fa"))
                    .environment(\.layoutDirection, .rightToLeft)
            }
            #else
            Sidebar()
            #endif
        }
    }
}

#Preview {
    MainView()
}
