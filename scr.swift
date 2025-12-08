//
//  scr.swift
//  ssssss
//
//  Created by Hesamoddin Saeedi on 12/1/25.
//

import SwiftUI

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ContentHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ViewportHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ScrollOffsetWithMaxHeight: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var contentHeight: CGFloat = 0
    @State private var viewportHeight: CGFloat = 0
    @State private var scrollPercentage: CGFloat = 0  // ← Make this @State, not computed!
    @State private var hasAppeared: Bool = false
    
    // Computed property for maximum scrollable distance
    var maxScrollOffset: CGFloat {
        max(0, contentHeight - viewportHeight)
    }
    
    // Computed property for scroll percentage (0.0 to 1.0) - used for calculation only
    var calculatedScrollPercentage: CGFloat {
        guard maxScrollOffset > 0 else { return 0 }
        return min(1.0, max(0.0, scrollOffset / maxScrollOffset))
    }
    
    // Computed property to check if scrolled to bottom
    var isAtBottom: Bool {
        guard maxScrollOffset > 0 else { return true }
        return scrollOffset >= maxScrollOffset - 1 // 1pt threshold for floating point precision
    }
    
    let description = "محصول بسیار ويژه برای کاربرانی که به شدت همراه بهترین خدمات را در دست آوردند"
    
    var arrayText: [String] {
        description.components(separatedBy: " ").filter { !$0.isEmpty }
    }
    
    var sequentialAttributedText: AttributedString {
        var attributed = AttributedString("")
        let totalWords = arrayText.count
        guard totalWords > 0 else { return attributed }
        
        let revealProgress = scrollPercentage * CGFloat(totalWords)
        
        for (index, word) in arrayText.enumerated() {
            var chunk = AttributedString(word)
            let hasRevealed = CGFloat(index + 1) <= revealProgress
            chunk.foregroundColor = hasRevealed ? .black : Color.gray.opacity(0.45)
            
            attributed.append(chunk)
            
            if index < totalWords - 1 {
                attributed.append(AttributedString(" "))
            }
        }
        
        return attributed
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Rectangle()
                    .frame(height: 200)
                    .padding(.vertical, 100)
                
                Text(sequentialAttributedText)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .animation(.spring(duration: 0.9), value: scrollPercentage)
                    .padding(.horizontal)
                
                Spacer()
                    .frame(height: 1000)
            }
            .frame(maxWidth: .infinity)
            // Track scroll offset and content height using background GeometryReader
            .background(
                GeometryReader { geo in
                    let height = geo.size.height
                    let offset = -geo.frame(in: .named("scroll")).minY
                    Color.clear
                        .preference(
                            key: ScrollOffsetKey.self,
                            value: max(0, offset)
                        )
                        .preference(
                            key: ContentHeightKey.self,
                            value: height
                        )
                        .onChange(of: height) { newHeight in
                            if newHeight > 0 {
                                contentHeight = newHeight
                                scrollPercentage = calculatedScrollPercentage
                            }
                        }
                }
            )
        }
        .coordinateSpace(name: "scroll")
        .overlay(
            // Measure viewport height using overlay
            GeometryReader { geo in
                let height = geo.size.height
                Color.clear
                    .preference(
                        key: ViewportHeightKey.self,
                        value: height
                    )
                    .onAppear {
                        viewportHeight = height
                    }
                    .onChange(of: height) { newHeight in
                        if newHeight > 0 {
                            viewportHeight = newHeight
                        }
                    }
            }
        )
        .onPreferenceChange(ScrollOffsetKey.self) { value in
            scrollOffset = max(0, value)  // Ensure non-negative
            scrollPercentage = calculatedScrollPercentage
            print("Scroll Offset: \(scrollOffset), Content: \(contentHeight), Viewport: \(viewportHeight), Max: \(maxScrollOffset), Progress: \(scrollPercentage)")
        }
        .onPreferenceChange(ContentHeightKey.self) { value in
            // Update content height and recalculate percentage
            // Remove the > 0 check to allow updates even during layout
            let oldHeight = contentHeight
            contentHeight = value
            // Only update percentage if height actually changed to avoid unnecessary recalculations
            if abs(oldHeight - value) > 0.1 {
                scrollPercentage = calculatedScrollPercentage
                print("Content Height: \(value), Old: \(oldHeight), Progress: \(scrollPercentage)")
            }
        }
        .onPreferenceChange(ViewportHeightKey.self) { value in
            if value > 0 {
                viewportHeight = value
                scrollPercentage = calculatedScrollPercentage  // ← Update @State here!
                print("Viewport Height: \(value)")
            }
        }
        .onAppear {
            hasAppeared = true
            // Force recalculation after layout
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                scrollPercentage = calculatedScrollPercentage
            }
        }
        .overlay(
            // Debug overlay (remove in production)
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 4) {
                    Text("Scroll Offset: \(Int(scrollOffset))")
                    Text("Content Height: \(Int(contentHeight))")
                    Text("Viewport Height: \(Int(viewportHeight))")
                    Text("Max Scroll: \(Int(maxScrollOffset))")
                    Text("Progress: \(Int(scrollPercentage * 100))%")
                    Text("At Bottom: \(isAtBottom ? "Yes" : "No")")
                }
                .font(.caption)
                .padding(8)
                .background(Color.black.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding()
            }
        )
    }
}

#Preview {
    ScrollOffsetWithMaxHeight()
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

