//
//  HafezFaalView.swift
//  Meikade
//
//  Created by Armin on 1/6/24.
//

import SwiftUI

struct HafezFaalView {
    @State private var showPoem = false
    @State private var selectedPoem: Int? = nil
    @GestureState private var fingerLocation: CGPoint? = nil
    
    private var position: Int? {
        if let fingerLocation {
            return Int(fingerLocation.x / 10)
        } else {
            return nil
        }
    }
    
    private var fingerDrag: some Gesture {
        DragGesture()
            .updating($fingerLocation) { (value, fingerLocation, transaction) in
                fingerLocation = value.location
            }
            .onEnded { value in
                if selectedPoem != nil {
                    showPoem = true
                }
            }
    }
}

extension HafezFaalView: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                /// Cover of the book
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.accent.gradient)
                        .frame(maxWidth: 10, maxHeight: proxy.size.height * 0.8)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [
                                        .red,
                                        .accent,
                                        .accent,
                                        .accent,
                                        .accent,
                                        .accent,
                                        .accent,
                                        .red,
                                    ]
                                ),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(maxWidth: min(proxy.size.width * 0.6, 350), maxHeight: proxy.size.height * 0.8)
                    
                    Rectangle()
                        .fill(Color.accent.gradient)
                        .frame(maxWidth: 10, maxHeight: proxy.size.height * 0.8)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .environment(\.colorScheme , .light)
                
                /// Pages of the book
                HStack(spacing: 0) {
                    ForEach(0...30, id: \.self) { _ in
                        Rectangle()
                            .fill(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        Divider()
                    }
                }
                .frame(maxWidth: min(proxy.size.width * 0.6, 350), maxHeight: proxy.size.height * 0.78)
                .overlay(alignment: .top) {
                    Image(systemName: "bubble.middle.bottom.fill")
                        .font(.system(size: 54))
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 54)
                        .shadow(radius: 2)
                        .overlay(alignment: .center) {
                            if let selectedPoem {
                                Text((selectedPoem - 2129).formatted())
                                    .offset(y: -5)
                                    .foregroundStyle(.black)
                            }
                        }
                        .opacity(fingerLocation == nil ? 0 : 1)
                        .position(x: min(max(fingerLocation?.x ?? 0 , 0), min(proxy.size.width * 0.6, 350)))
                        .offset(y: -28)
                        .onChange(of: position) { _ in
                            if let x = fingerLocation?.x,
                               x >= 0,
                               x <= min(proxy.size.width * 0.6, 350) {
                                selectedPoem = Int.random(in: 2130..<2625)
                                #if os(iOS)
                                HapticFeedback.shared.start(.soft)
                                #endif
                            }
                        }
                }
                .gesture(fingerDrag)
                .environment(\.layoutDirection , .leftToRight)
            }
        }
        .background {
            #if !os(visionOS)
            Image(.cover)
                .resizable()
                .grayscale(1)
                .aspectRatio(contentMode: .fill)
                .blur(radius: 5)
                .padding(-8)
                .ignoresSafeArea(.all)
            #endif
        }
        .navigationDestination(isPresented: $showPoem) {
            PoemView(poemType: .poem(id: selectedPoem ?? 0))
        }
        .navigationTitle("")
        #if os(macOS)
        .presentedWindowStyle(.hiddenTitleBar)
        .presentedWindowToolbarStyle(.unified(showsTitle: false))
        #endif
    }
}

#Preview {
    HafezFaalView()
        .environment(\.locale, .init(identifier: "fa"))
}
