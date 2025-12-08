import SwiftUI

// MARK: - Gradient Corner Examples
// This file demonstrates how to specify gradient corners in SwiftUI

struct GradientCornerExamples: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Gradient Corner Reference")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                // Example 1: Top Leading to Bottom Trailing (diagonal)
                gradientExample(
                    title: "Top Leading → Bottom Trailing",
                    colors: [.black, .red, .black],
                    start: .topLeading,
                    end: .bottomTrailing
                )
                
                // Example 2: Top Trailing to Bottom Leading (diagonal opposite)
                gradientExample(
                    title: "Top Trailing → Bottom Leading",
                    colors: [.blue, .purple],
                    start: .topTrailing,
                    end: .bottomLeading
                )
                
                // Example 3: Top to Bottom (vertical)
                gradientExample(
                    title: "Top → Bottom (Vertical)",
                    colors: [.green, .yellow],
                    start: .top,
                    end: .bottom
                )
                
                // Example 4: Leading to Trailing (horizontal)
                gradientExample(
                    title: "Leading → Trailing (Horizontal)",
                    colors: [.orange, .pink],
                    start: .leading,
                    end: .trailing
                )
                
                // Example 5: Bottom Leading to Top Trailing
                gradientExample(
                    title: "Bottom Leading → Top Trailing",
                    colors: [.cyan, .blue],
                    start: .bottomLeading,
                    end: .topTrailing
                )
                
                // Example 6: Bottom Trailing to Top Leading
                gradientExample(
                    title: "Bottom Trailing → Top Leading",
                    colors: [.red, .orange],
                    start: .bottomTrailing,
                    end: .topLeading
                )
                
                // Example 7: Custom point
                Text("Custom Point (0.3, 0.3) → (0.7, 0.7)")
                    .font(.headline)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .pink],
                            startPoint: UnitPoint(x: 0.3, y: 0.3),
                            endPoint: UnitPoint(x: 0.7, y: 0.7)
                        )
                    )
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }
            .padding()
        }
    }
    
    func gradientExample(title: String, colors: [Color], start: UnitPoint, end: UnitPoint) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("Sample Text")
                .font(.title2)
                .bold()
                .foregroundStyle(
                    LinearGradient(
                        colors: colors,
                        startPoint: start,
                        endPoint: end
                    )
                )
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
        }
    }
}

// MARK: - Quick Reference Card
struct GradientQuickReference: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("UnitPoint Options")
                .font(.headline)
            
            Group {
                Text("Corners:")
                    .font(.subheadline)
                    .bold()
                Text("• .topLeading (top-left)")
                Text("• .topTrailing (top-right)")
                Text("• .bottomLeading (bottom-left)")
                Text("• .bottomTrailing (bottom-right)")
                
                Text("Edges:")
                    .font(.subheadline)
                    .bold()
                    .padding(.top, 8)
                Text("• .top (top center)")
                Text("• .bottom (bottom center)")
                Text("• .leading (left center)")
                Text("• .trailing (right center)")
                
                Text("Center:")
                    .font(.subheadline)
                    .bold()
                    .padding(.top, 8)
                Text("• .center")
            }
            .font(.caption)
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}

// MARK: - Usage in AnimatedTextView
struct GradientAnimatedTextExample: View {
    var body: some View {
        VStack(spacing: 20) {
            // Your original example - black to red to black
            AnimatedTextView(
                text: "Gradient Text",
                animationStyle: .fadeIn,
                fontSize: 32,
                fontWeight: .bold,
                gradientColors: [.black, .red, .black],
                gradientStartPoint: .topLeading,  // Start from top-left
                gradientEndPoint: .bottomTrailing // End at bottom-right
            )
            
            // Alternative: Top to Bottom
            AnimatedTextView(
                text: "Vertical Gradient",
                animationStyle: .slideFromBottom,
                delay: 0.3,
                fontSize: 28,
                fontWeight: .semibold,
                gradientColors: [.blue, .purple],
                gradientStartPoint: .top,
                gradientEndPoint: .bottom
            )
        }
        .padding()
    }
}

// MARK: - Preview
struct GradientCornerExamples_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GradientCornerExamples()
            GradientQuickReference()
        }
    }
}


