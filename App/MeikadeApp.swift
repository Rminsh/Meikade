//
//  MeikadeApp.swift
//  Meikade
//
//  Created by Armin on 12/20/23.
//

import SwiftUI

@main
struct MeikadeApp: App {
    var body: some Scene {
        WindowGroup {
            ExploreView()
                .environment(\.locale, .init(identifier: "fa"))
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
