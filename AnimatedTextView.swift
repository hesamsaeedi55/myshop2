import SwiftUI

// MARK: - Gradient Corner Reference
/*
 To specify which corner/point a gradient starts/ends from, use UnitPoint:
 
 CORNERS:
 - .topLeading      (top-left corner)
 - .topTrailing     (top-right corner)
 - .bottomLeading   (bottom-left corner)
 - .bottomTrailing  (bottom-right corner)
 
 EDGES:
 - .top             (top center)
 - .bottom          (bottom center)
 - .leading         (left center)
 - .trailing        (right center)
 
 CENTER:
 - .center          (center point)
 
 CUSTOM:
 - UnitPoint(x: 0.5, y: 0.5)  (custom point, 0.0 to 1.0)
 
 Examples:
 - Top to Bottom: startPoint: .top, endPoint: .bottom
 - Left to Right: startPoint: .leading, endPoint: .trailing
 - Top-left to Bottom-right: startPoint: .topLeading, endPoint: .bottomTrailing
 - Top-right to Bottom-left: startPoint: .topTrailing, endPoint: .bottomLeading
 */

// MARK: - Animated Text View
struct AnimatedTextView: View {
    let text: String
    var animationStyle: AnimationStyle = .fadeIn
    var delay: Double = 0
    var duration: Double = 0.8
    var fontSize: CGFloat = 24
    var fontWeight: Font.Weight = .regular
    var color: Color = .primary
    
    // Gradient support
    var gradientColors: [Color]? = nil
    var gradientStartPoint: UnitPoint = .topLeading
    var gradientEndPoint: UnitPoint = .bottomTrailing
    
    enum AnimationStyle {
        case fadeIn
        case slideFromBottom
        case slideFromTop
        case slideFromLeading
        case slideFromTrailing
        case scaleUp
        case typewriter
        case bounce
    }
    
    @State private var isVisible = false
    @State private var displayedText = ""
    @State private var opacity: Double = 0
    @State private var offset: CGFloat = 0
    @State private var scale: CGFloat = 0.5
    
    var body: some View {
        Group {
            if let gradientColors = gradientColors {
                Text(displayedText.isEmpty ? text : displayedText)
                    .font(.system(size: fontSize, weight: fontWeight))
                    .foregroundStyle(
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: gradientStartPoint,
                            endPoint: gradientEndPoint
                        )
                    )
                    .opacity(opacity)
                    .offset(y: offset)
                    .scaleEffect(scale)
            } else {
                Text(displayedText.isEmpty ? text : displayedText)
                    .font(.system(size: fontSize, weight: fontWeight))
                    .foregroundColor(color)
                    .opacity(opacity)
                    .offset(y: offset)
                    .scaleEffect(scale)
            }
        }
        .onAppear {
            animateText()
        }
    }
    
    private func animateText() {
        switch animationStyle {
        case .fadeIn:
            withAnimation(.easeIn(duration: duration).delay(delay)) {
                opacity = 1
            }
            
        case .slideFromBottom:
            offset = 50
            opacity = 0
            withAnimation(.spring(response: duration, dampingFraction: 0.7).delay(delay)) {
                opacity = 1
                offset = 0
            }
            
        case .slideFromTop:
            offset = -50
            opacity = 0
            withAnimation(.spring(response: duration, dampingFraction: 0.7).delay(delay)) {
                opacity = 1
                offset = 0
            }
            
        case .slideFromLeading:
            offset = -50
            opacity = 0
            withAnimation(.spring(response: duration, dampingFraction: 0.7).delay(delay)) {
                opacity = 1
                offset = 0
            }
            
        case .slideFromTrailing:
            offset = 50
            opacity = 0
            withAnimation(.spring(response: duration, dampingFraction: 0.7).delay(delay)) {
                opacity = 1
                offset = 0
            }
            
        case .scaleUp:
            scale = 0.3
            opacity = 0
            withAnimation(.spring(response: duration, dampingFraction: 0.6).delay(delay)) {
                opacity = 1
                scale = 1.0
            }
            
        case .typewriter:
            displayedText = ""
            opacity = 1
            let characters = Array(text)
            for (index, character) in characters.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay + Double(index) * 0.05) {
                    displayedText += String(character)
                }
            }
            
        case .bounce:
            scale = 0.5
            opacity = 0
            withAnimation(.spring(response: duration, dampingFraction: 0.4).delay(delay)) {
                opacity = 1
                scale = 1.0
            }
        }
    }
}

// MARK: - Usage Examples
struct AnimatedTextExamples: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                // Fade In
                AnimatedTextView(
                    text: "Fade In Animation",
                    animationStyle: .fadeIn,
                    fontSize: 28,
                    fontWeight: .bold
                )
                
                // Slide From Bottom
                AnimatedTextView(
                    text: "Slide From Bottom",
                    animationStyle: .slideFromBottom,
                    delay: 0.2,
                    fontSize: 28,
                    fontWeight: .semibold,
                    color: .blue
                )
                
                // Slide From Top
                AnimatedTextView(
                    text: "Slide From Top",
                    animationStyle: .slideFromTop,
                    delay: 0.4,
                    fontSize: 28,
                    fontWeight: .semibold,
                    color: .green
                )
                
                // Scale Up
                AnimatedTextView(
                    text: "Scale Up Animation",
                    animationStyle: .scaleUp,
                    delay: 0.6,
                    fontSize: 28,
                    fontWeight: .bold,
                    color: .purple
                )
                
                // Typewriter Effect
                AnimatedTextView(
                    text: "Typewriter Effect - Characters appear one by one!",
                    animationStyle: .typewriter,
                    delay: 0.8,
                    fontSize: 20,
                    fontWeight: .medium,
                    color: .orange
                )
                
                // Bounce
                AnimatedTextView(
                    text: "Bounce Animation",
                    animationStyle: .bounce,
                    delay: 1.0,
                    fontSize: 32,
                    fontWeight: .bold,
                    color: .red
                )
                
                // Gradient Examples with Different Corners
                VStack(spacing: 20) {
                    Text("Gradient Examples")
                        .font(.headline)
                        .padding(.top)
                    
                    // Top Leading to Bottom Trailing (diagonal)
                    AnimatedTextView(
                        text: "Top Leading → Bottom Trailing",
                        animationStyle: .fadeIn,
                        delay: 1.2,
                        fontSize: 20,
                        fontWeight: .bold,
                        gradientColors: [.black, .red, .black],
                        gradientStartPoint: .topLeading,
                        gradientEndPoint: .bottomTrailing
                    )
                    
                    // Top to Bottom (vertical)
                    AnimatedTextView(
                        text: "Top → Bottom",
                        animationStyle: .fadeIn,
                        delay: 1.4,
                        fontSize: 20,
                        fontWeight: .bold,
                        gradientColors: [.blue, .purple],
                        gradientStartPoint: .top,
                        gradientEndPoint: .bottom
                    )
                    
                    // Leading to Trailing (horizontal)
                    AnimatedTextView(
                        text: "Leading → Trailing",
                        animationStyle: .fadeIn,
                        delay: 1.6,
                        fontSize: 20,
                        fontWeight: .bold,
                        gradientColors: [.green, .yellow, .green],
                        gradientStartPoint: .leading,
                        gradientEndPoint: .trailing
                    )
                    
                    // Top Trailing to Bottom Leading
                    AnimatedTextView(
                        text: "Top Trailing → Bottom Leading",
                        animationStyle: .fadeIn,
                        delay: 1.8,
                        fontSize: 20,
                        fontWeight: .bold,
                        gradientColors: [.orange, .pink, .orange],
                        gradientStartPoint: .topTrailing,
                        gradientEndPoint: .bottomLeading
                    )
                }
            }
            .padding()
        }
    }
}

// MARK: - Staggered Text Animation (Multiple lines)
struct StaggeredAnimatedText: View {
    let texts: [String]
    var animationStyle: AnimatedTextView.AnimationStyle = .fadeIn
    var staggerDelay: Double = 0.1
    var fontSize: CGFloat = 20
    var fontWeight: Font.Weight = .regular
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(texts.enumerated()), id: \.offset) { index, text in
                AnimatedTextView(
                    text: text,
                    animationStyle: animationStyle,
                    delay: Double(index) * staggerDelay,
                    fontSize: fontSize,
                    fontWeight: fontWeight
                )
            }
        }
    }
}

// MARK: - Preview
struct AnimatedTextView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedTextExamples()
    }
}

