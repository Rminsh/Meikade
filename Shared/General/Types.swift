//
//  Types.swift
//  Meikade
//
//  Created by Armin on 1/11/24.
//

import SwiftUI

#if canImport(AppKit)
public typealias UXViewRepresentable = NSViewRepresentable
public typealias UXColor = NSColor
public typealias UXFont = NSFont
public typealias UXImage = NSImage

#elseif canImport(UIKit)
#if !os(watchOS)
public typealias UXViewRepresentable = UIViewRepresentable
#endif
public typealias UXColor = UIColor
public typealias UXFont = UIFont
public typealias UXImage = UIImage
#endif
