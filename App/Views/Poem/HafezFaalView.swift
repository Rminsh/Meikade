//
//  HafezFaalView.swift
//  Meikade
//
//  Created by Armin on 1/6/24.
//

import SwiftUI

struct HafezFaalView: View {
    
    @State var expanded = true
    @State var showPoem = false
    @State var configuration = PrismConfiguration(
        tilt: 0.5,
        size: CGSize(width: 120, height: 180),
        extrusion: 20,
        shadowOpacity: 0.25
    )
    
    var body: some View {
        VStack {
            hafezBook
                .frame(maxHeight: .infinity)
                .navigationDestination(isPresented: $showPoem) {
                    PoemView(poemType: .poem(id: Int.random(in: 2130..<2625)))
                }
            
            Group {
                if expanded {
                    Text("Make a wish and tap for a sign")
                        .customFont(name: .shekasteh, style: .title1)
                        .foregroundStyle(.white)
                        .shadow(radius: 25)
                } else {
                    ProgressView()
                        .tint(.accent)
                        .offset(y: -32)
                }
            }
            .padding()
        }
        .background {
            Image(.cover)
                .resizable()
                .grayscale(1)
                .aspectRatio(contentMode: .fill)
                .blur(radius: 5)
                .padding(-8)
                .ignoresSafeArea(.all)
        }
        .navigationTitle("")
        #if os(macOS)
        .presentedWindowStyle(.hiddenTitleBar)
        .presentedWindowToolbarStyle(.unified(showsTitle: false))
        #endif
    }
    
    var hafezBook: some View {
        PrismCanvas(tilt: configuration.tilt) {
            Button {
                withAnimation {
                    expanded = false
                }
            } label: {
                PrismView(configuration: configuration) {
                    ZStack {
                        Image(.cover)
                            .resizable()
                            .blur(radius: 0.8)
                        
                        Text("Hafez Divination")
                            .customFont(name: .shekasteh, style: .title1)
                            .foregroundStyle(.white)
                    }
                } left: {
                    Rectangle()
                        .fill(Color.white.gradient)
                } right: {
                    Image(.cover)
                        .resizable()
                        .blur(radius: 1)
                }
                .offset(y: 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .buttonStyle(.scaling)
        }
        .onChange(of: expanded) { newValue in
            withAnimation(.spring()) {
                if newValue {
                    configuration.tilt = 0.5
                    configuration.extrusion = 20
                    configuration.shadowOpacity = 0.25
                } else {
                    configuration.tilt = 0
                    configuration.extrusion = 0
                    configuration.shadowOpacity = 0
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showPoem = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            expanded = true
                        }
                    }
                }
            }
        }
        .environment(\.layoutDirection, .leftToRight)
    }
}

#Preview {
    HafezFaalView()
}
