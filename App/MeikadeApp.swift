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
                #if !os(macOS)
                .environment(\.locale, .init(identifier: "fa"))
                .environment(\.layoutDirection, .rightToLeft)
                #endif
        }
    }
}

#if os(iOS) || os(visionOS)
extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBar.topItem?.backButtonDisplayMode = .minimal
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.clear]
    }
}
#endif
