//
//  BookSelectorView.swift
//  Meikade
//
//  Created by Armin on 5/27/24.
//

import SwiftUI

struct BookSelectorView {
    @Binding var selectedPoem: Int?
    @State private var selectedPoemTemp: Int?
    
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
                if selectedPoemTemp != nil {
                    selectedPoem = selectedPoemTemp
                }
            }
    }
    
    #if os(watchOS)
    let maxPageCount: Int = 30
    let bookThickness: CGFloat = 5
    #else
    let maxPageCount: Int = 50
    let bookThickness: CGFloat = 10
    #endif
}
    
extension BookSelectorView: View {
    var body: some View {
        GeometryReader { proxy in
            #if os(watchOS)
            let bookHeight = proxy.size.height
            #else
            let bookHeight = proxy.size.height * 0.8
            #endif
            let bookInnerWidth = min(proxy.size.width * 0.5, 300)
            
            ZStack {
                /// Cover of the book
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(.book.gradient)
                        .frame(maxWidth: bookThickness, maxHeight: bookHeight)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [
                                        .red,
                                        .book,
                                        .book,
                                        .book,
                                        .book,
                                        .book,
                                        .book,
                                        .red,
                                    ]
                                ),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(maxWidth: bookInnerWidth, maxHeight: bookHeight)
                    
                    Rectangle()
                        .fill(.book.gradient)
                        .frame(maxWidth: bookThickness, maxHeight: bookHeight)
                }
                .clipShape(RoundedRectangle(cornerRadius: bookThickness))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .environment(\.colorScheme , .light)
                
                /// Pages of the book
                HStack(spacing: 0) {
                    ForEach(0...maxPageCount, id: \.self) { _ in
                        Rectangle()
                            .fill(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        Divider()
                    }
                }
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(.book.gradient)
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
                        #if os(watchOS)
                        .font(.system(size: 36))
                        #else
                        .font(.system(size: 54))
                        #endif
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 54)
                        .shadow(radius: 2)
                        .overlay(alignment: .center) {
                            if let selectedPoemTemp {
                                Text((selectedPoemTemp - 2129).formatted())
                                    #if os(watchOS)
                                    .font(.footnote)
                                    #endif
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
                                DispatchQueue.main.async {
                                    selectedPoemTemp = Int.random(in: 2130..<2625)
                                    #if os(iOS)
                                    HapticFeedback.shared.start(.soft)
                                    #endif
                                }
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
    return BookSelectorView(selectedPoem: $selectedPoem)
}
