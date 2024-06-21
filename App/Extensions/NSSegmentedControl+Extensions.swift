//
//  NSSegmentedControl+Extensions.swift
//  Meikade
//
//  Created by Armin on 6/21/24.
//

#if canImport(AppKit)
import AppKit

extension NSSegmentedControl {
    open override func viewWillDraw() {
        self.font = UXFont.custom(style: .body)
    }
}
#endif
