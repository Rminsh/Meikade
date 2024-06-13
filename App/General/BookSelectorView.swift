//
//  BookSelectorView.swift
//  Meikade
//
//  Created by Armin on 5/27/24.
//

import SwiftUI

struct BookSelectorView {
    @Binding var showDetail: Bool
    @Binding var selectedPoem: Int?
    
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
                    showDetail = true
                }
            }
    }
}
    
extension BookSelectorView: View {
    var body: some View {
        GeometryReader { proxy in
            let bookHeight = proxy.size.height * 0.8
            let bookInnerWidth = min(proxy.size.width * 0.5, 300)
            
            ZStack {
                /// Cover of the book
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.accent.gradient)
                        .frame(maxWidth: 10, maxHeight: bookHeight)
                    
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
                        .frame(maxWidth: bookInnerWidth, maxHeight: bookHeight)
                    
                    Rectangle()
                        .fill(Color.accent.gradient)
                        .frame(maxWidth: 10, maxHeight: proxy.size.height * 0.8)
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .environment(\.colorScheme , .light)
                
                /// Pages of the book
                HStack(spacing: 0) {
                    ForEach(0...50, id: \.self) { _ in
                        Rectangle()
                            .fill(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        Divider()
                    }
                }
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(.accent.gradient)
                        .environment(\.colorScheme , .light)
                        .frame(maxWidth: 5)
                        .opacity(fingerLocation == nil ? 0 : 1)
                        .position(
                            x: min(max(fingerLocation?.x ?? 0 , 0), bookInnerWidth),
                            y: bookHeight * 0.975 / 2
                        )
                }
                .frame(maxWidth: bookInnerWidth, maxHeight: bookHeight * 0.975)
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
                        .position(x: min(max(fingerLocation?.x ?? 0 , 0), bookInnerWidth))
                        .offset(y: -28)
                        .onChange(of: position) { _ in
                            if let x = fingerLocation?.x,
                               x >= 0,
                               x <= bookInnerWidth {
                                selectedPoem = Int.random(in: 2130..<2625)
                                #if os(iOS)
                                DispatchQueue.main.async {
                                    HapticFeedback.shared.start(.soft)
                                }
                                #endif
                            }
                        }
                }
                .gesture(fingerDrag)
                .environment(\.layoutDirection , .leftToRight)
            }
        }
    }
}

#Preview {
    @State var selectedPoem: Int? = nil
    return BookSelectorView(
        showDetail: .constant(false),
        selectedPoem: $selectedPoem
    )
}
