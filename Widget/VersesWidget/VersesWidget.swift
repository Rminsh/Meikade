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
    
    #if os(iOS)
    let families: [WidgetFamily] = [
        .systemSmall,
        .systemMedium,
        .accessoryRectangular
    ]
    #else
    let families: [WidgetFamily] = [
        .systemSmall,
        .systemMedium
    ]
    #endif

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: VersesProvider()) { entry in
            VersesEntryView(entry: entry)
        }
        .supportedFamilies(families)
    }
}

struct VersesEntryView: View {
    
    var entry: VersesEntry
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        switch widgetFamily {
        #if os(iOS)
        case .accessoryRectangular:
            VersesCompactView(entry: entry)
        #endif
        default:
            VersesView(entry: entry)
        }
    }
}

#Preview(as: .systemSmall) {
    VersesWidget()
} timeline: {
    VersesEntry(
        date: .now,
        poem: .placeholder,
        image: nil
    )
}
