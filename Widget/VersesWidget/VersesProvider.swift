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
        Task {
            let poem: Poem = await loadPoem(in: context)
            let entry: VersesEntry = VersesEntry(date: Date(), poem: poem)
            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<VersesEntry>) -> ()) {
        Task {
            let now: Date = Date()
            let nextUpdate: Date = now.addingTimeInterval(10800) /// 3 hour
            let poem: Poem = await loadPoem(in: context)
            let entry: VersesEntry = VersesEntry(date: Date(), poem: poem)
            let timeline: Timeline<VersesEntry> = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }
    
    func loadPoem(in context: Context) async -> Poem {
        let service = MeikadeService()
        
        if context.isPreview {
            return .placeholder
        }
        
        do {
            return try await service.getRandomPoem(verseLimit: 2, verseOffset: 0, poetID: 2)
        } catch {
            return Poem.loadCachedPoem() ?? Poem.placeholder
        }
    }
}
