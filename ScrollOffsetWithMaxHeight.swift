import SwiftUI

// Helper extension for conditional modifiers
extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    // Conditional color invert that maintains view identity for animation
    func conditionalColorInvert(_ condition: Bool) -> some View {
        self.modifier(ConditionalColorInvertModifier(shouldInvert: condition))
    }
}

struct ConditionalColorInvertModifier: ViewModifier {
    let shouldInvert: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                content.colorInvert()
                    .opacity(shouldInvert ? 1 : 0)
                    .allowsHitTesting(false)
            )
    }
}

// Preference keys for tracking scroll metrics
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
    @State private var scrollPercentage: CGFloat = 0
    
    // Computed property for maximum scrollable distance
    var maxScrollOffset: CGFloat {
        max(0, contentHeight - viewportHeight)
    }
    
    // Computed property for scroll percentage (0.0 to 1.0)
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
    
    // Computed property to count words in description
    var wordCount: Int {
        description
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .count
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Top marker - tracks scroll offset
                GeometryReader { geo in
                    Color.clear
                        .preference(
                            key: ScrollOffsetKey.self,
                            value: -geo.frame(in: .named("scroll")).minY
                        )
                }
                .frame(height: 0)
                
                // Your scrollable content
                ForEach(0..<50) { i in
                    Text("Row \(i)")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                        .foregroundStyle(scrollPercentage > 0.5 ? .red : .primary)
                        .conditionalColorInvert(scrollPercentage > 0.5)
                        .animation(.spring(duration: 1.2), value: scrollPercentage)
                }
            }
            .frame(maxWidth: .infinity)
            .background(
                GeometryReader { geo in
                    let height = geo.size.height
                    Color.clear
                        .preference(
                            key: ContentHeightKey.self,
                            value: height
                        )
                        .onAppear {
                            contentHeight = height
                        }
                        .onChange(of: height) { newHeight in
                            if newHeight > 0 {
                                contentHeight = newHeight
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
            scrollOffset = value
            scrollPercentage = calculatedScrollPercentage
            print("Scroll Offset: \(value)")
        }
        .onPreferenceChange(ContentHeightKey.self) { value in
            if value > 0 {
                contentHeight = value
                scrollPercentage = calculatedScrollPercentage
                print("Content Height: \(value)")
            }
        }
        .onPreferenceChange(ViewportHeightKey.self) { value in
            if value > 0 {
                viewportHeight = value
                scrollPercentage = calculatedScrollPercentage
                print("Viewport Height: \(value)")
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

