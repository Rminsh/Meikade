//
//  Sidebar.swift
//  Meikade
//
//  Created by Armin on 1/8/24.
//

import SwiftUI

struct Sidebar: View {
    
    @State var selection: Panel? = .explore
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                ForEach(Panel.allCases, id: \.self) { item in
                    NavigationLink(value: item) {
                        Label(item.title, systemImage: item.icon)
                            .font(.customFont(style: .body))
                    }
                }
            }
            #if !os(watchOS)
            .listStyle(.sidebar)
            #endif
            .navigationTitle("")
        } detail: {
            selection?.view()
        }
        #if os(macOS)
        .frame(minWidth: 700)
        #endif
    }
}

#Preview {
    Sidebar()
}
