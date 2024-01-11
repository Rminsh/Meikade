//
//  VersesWidget.swift
//  Widget
//
//  Created by Armin on 1/6/24.
//

import WidgetKit
import SwiftUI

struct VersesWidget: Widget {
    let kind: String = "VersesWidget"
    
    let families: [WidgetFamily] = [
            .systemSmall,
            .systemMedium,
        ]

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: VersesProvider()) { entry in
            VersesView(entry: entry)
        }
        .supportedFamilies(families)
    }
}

@available(iOS 17.0, macOS 14.0, *)
#Preview(as: .systemSmall) {
    VersesWidget()
} timeline: {
    VersesEntry(date: .now, poem: .placeholder)
}
