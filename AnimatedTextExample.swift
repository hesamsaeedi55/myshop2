import SwiftUI

// MARK: - Simple Example: Animated Text When View Opens
struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Main title with fade in
            AnimatedTextView(
                text: "Welcome!",
                animationStyle: .fadeIn,
                duration: 1.0,
                fontSize: 48,
                fontWeight: .bold,
                color: .blue
            )
            
            // Subtitle with slide from bottom
            AnimatedTextView(
                text: "Your journey starts here",
                animationStyle: .slideFromBottom,
                delay: 0.3,
                duration: 0.8,
                fontSize: 20,
                fontWeight: .medium,
                color: .secondary
            )
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Advanced Example: Multiple Animated Texts
struct ProductDetailView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Product title with scale up
            AnimatedTextView(
                text: "Premium Product",
                animationStyle: .scaleUp,
                duration: 0.6,
                fontSize: 32,
                fontWeight: .bold
            )
            
            // Price with slide from leading
            AnimatedTextView(
                text: "$99.99",
                animationStyle: .slideFromLeading,
                delay: 0.2,
                fontSize: 28,
                fontWeight: .semibold,
                color: .green
            )
            
            // Description with typewriter effect
            AnimatedTextView(
                text: "This is an amazing product that will change your life!",
                animationStyle: .typewriter,
                delay: 0.4,
                fontSize: 16,
                color: .secondary
            )
        }
        .padding()
    }
}

// MARK: - Staggered List Example
struct FeatureListView: View {
    let features = [
        "Fast Performance",
        "Secure & Safe",
        "Easy to Use",
        "24/7 Support"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AnimatedTextView(
                text: "Features",
                animationStyle: .fadeIn,
                fontSize: 24,
                fontWeight: .bold
            )
            
            StaggeredAnimatedText(
                texts: features,
                animationStyle: .slideFromBottom,
                staggerDelay: 0.15,
                fontSize: 18
            )
        }
        .padding()
    }
}

// MARK: - Preview
struct AnimatedTextExample_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WelcomeView()
                .previewDisplayName("Welcome View")
            
            ProductDetailView()
                .previewDisplayName("Product Detail")
            
            FeatureListView()
                .previewDisplayName("Feature List")
        }
    }
}

