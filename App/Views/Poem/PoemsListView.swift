//
//  PoemsListView.swift
//  Meikade
//
//  Created by Armin on 12/29/23.
//

import SwiftUI

struct PoemsListView {
    var poetID: Int
    var categoryID: Int
    
    @State var poems: [PoemDetail] = []
    
    func getPoems() async {
        let service = MeikadeService()
        do {
            poems = try await service.getPoems(
                poetID: poetID,
                categoryID: categoryID,
                offset: 0
            )
        } catch {
            
        }
    }
}

extension PoemsListView: View {
    
    var body: some View {
        List {
            ForEach(poems, id: \.id) { poem in
                Text(poem.title)
                    .customFont(style: .body)
            }
        }
        .task {
            await getPoems()
        }
    }
}

#Preview {
    PoemsListView(
        poetID: 2,
        categoryID: 24
    )
}
