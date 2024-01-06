//
//  VersesProvider.swift
//  WidgetExtension
//
//  Created by Armin on 1/6/24.
//

import SwiftUI
import WidgetKit

struct VersesEntry: TimelineEntry {
    let date: Date
    let poem: Poem?
}

struct VersesProvider: TimelineProvider {
    func placeholder(in context: Context) -> VersesEntry {
        VersesEntry(
            date: Date(),
            poem: .placeholder
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (VersesEntry) -> ()) {
        Task{
            let service = MeikadeService()
            let poem = try? await service.getRandomPoem(verseLimit: 2, verseOffset: 0)
            let entry = VersesEntry(date: Date(), poem: poem)
            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<VersesEntry>) -> ()) {
        Task {
            let now = Date()
            let nextUpdate = now.addingTimeInterval(10800) /// 3 hour
            let service = MeikadeService()
            let poem = try? await service.getRandomPoem(verseLimit: 2, verseOffset: 0, poetID: 2)
            let entry = VersesEntry(date: Date(), poem: poem)
            
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }
}
