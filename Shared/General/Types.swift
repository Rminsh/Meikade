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

#elseif canImport(UIKit)
public typealias UXViewRepresentable = UIViewRepresentable
public typealias UXColor = UIColor
public typealias UXFont = UIFont
#endif
