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
            MainView()
        }
    }
}

#if os(iOS) || os(visionOS)
extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBar.topItem?.backButtonDisplayMode = .minimal
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.clear]
        
        let tabBarAppearance = UITabBarAppearance()
        let fontAttribute: [NSAttributedString.Key : Any] = [.font: UXFont.custom(style: .caption2)]
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = fontAttribute
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = fontAttribute
        tabBarAppearance.compactInlineLayoutAppearance.normal.titleTextAttributes = fontAttribute
        tabBarAppearance.compactInlineLayoutAppearance.selected.titleTextAttributes = fontAttribute
        tabBarAppearance.inlineLayoutAppearance.normal.titleTextAttributes = fontAttribute
        tabBarAppearance.inlineLayoutAppearance.selected.titleTextAttributes = fontAttribute
        tabBarController?.tabBar.standardAppearance = tabBarAppearance
        tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppearance
    }
}
#endif
