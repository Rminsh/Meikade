//
//  MeikadeApp.swift
//  Meikade
//
//  Created by Armin on 12/20/23.
//

import SwiftUI

@main
struct MeikadeApp: App {
    
    init() {
        // Set the AppleLanguages user default to Farsi
        UserDefaults.standard.set(["fa"], forKey: "AppleLanguages")
        UserDefaults.standard.set(true, forKey: "AppleTextDirection")
        UserDefaults.standard.synchronize()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                #if !os(macOS)
                .environment(\.locale, .init(identifier: "fa"))
                .environment(\.layoutDirection, .rightToLeft)
                #endif
        }
    }
}
