//
//  UINavigationController+Extensions.swift
//  Meikade
//
//  Created by Armin on 1/15/24.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBar.topItem?.backButtonDisplayMode = .minimal
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.clear]
        
        // Tabbar custom appearance
        let tabBarAppearance = UITabBarAppearance()
        let fontAttribute: [NSAttributedString.Key : Any] = [.font: UXFont.custom(style: .caption2)]
        let offset: UIOffset = UIOffset(horizontal: 0, vertical: 5)
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = fontAttribute
        tabBarAppearance.stackedLayoutAppearance.selected.titlePositionAdjustment = offset
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = fontAttribute
        tabBarAppearance.stackedLayoutAppearance.normal.titlePositionAdjustment = offset
        tabBarAppearance.compactInlineLayoutAppearance.normal.titleTextAttributes = fontAttribute
        tabBarAppearance.compactInlineLayoutAppearance.normal.titlePositionAdjustment = offset
        tabBarAppearance.compactInlineLayoutAppearance.selected.titleTextAttributes = fontAttribute
        tabBarAppearance.compactInlineLayoutAppearance.selected.titlePositionAdjustment = offset
        tabBarAppearance.inlineLayoutAppearance.normal.titleTextAttributes = fontAttribute
        tabBarAppearance.inlineLayoutAppearance.normal.titlePositionAdjustment = offset
        tabBarAppearance.inlineLayoutAppearance.selected.titleTextAttributes = fontAttribute
        tabBarAppearance.inlineLayoutAppearance.selected.titlePositionAdjustment = offset
        tabBarController?.tabBar.standardAppearance = tabBarAppearance
        tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppearance
        
        // Segmented picker appearance
        UISegmentedControl.appearance().setTitleTextAttributes([.font: UXFont.custom(style: .caption1)], for: .normal)
    }
}
#endif
