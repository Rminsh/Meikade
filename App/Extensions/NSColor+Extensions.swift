//
//  Color+Extensions.swift
//  Meikade
//
//  Created by Armin on 1/11/24.
//

import SwiftUI

#if canImport(AppKit)
extension NSColor {
    static let label = NSColor.labelColor
}
#elseif os(watchOS)
extension UIColor {
    static let label = UIColor.white
}
#endif
