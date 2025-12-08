//
//  OverlayTextWrapFix.swift
//  Fix: Text not wrapping in overlay
//

import SwiftUI

struct OverlayTextWrapFix: View {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            Spacer()
            
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .frame(width: width * 2, height: height * 0.2)
                .background(CustomBlurView(effect: .systemUltraThinMaterialDark).opacity(0.6))
                .blur(radius: 25)
                .overlay {
                    // ✅ FIX: Add frame constraint to the text
                    Text("ست پاییزی قهوه‌ای به همراه بوت و کیف چرم")
                        .font(.custom("AbarHighNoEn-SemiBold", size: width/14, relativeTo: .body))
                        .multilineTextAlignment(.trailing)
                        .lineLimit(nil) // Allow multiple lines
                        .fixedSize(horizontal: false, vertical: true) // Allow vertical expansion
                        .frame(maxWidth: width * 2 - (width/50) * 2) // Constrain to parent width minus padding
                        .padding(.trailing, width/50)
                        .foregroundColor(.white)
                }
        }
    }
}

// MARK: - Alternative: Using padding on the overlay container
struct OverlayTextWrapFixV2: View {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            Spacer()
            
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .frame(width: width * 2, height: height * 0.2)
                .background(CustomBlurView(effect: .systemUltraThinMaterialDark).opacity(0.6))
                .blur(radius: 25)
                .overlay(alignment: .trailing) {
                    // ✅ FIX: Use alignment and frame
                    Text("ست پاییزی قهوه‌ای به همراه بوت و کیف چرم")
                        .font(.custom("AbarHighNoEn-SemiBold", size: width/14, relativeTo: .body))
                        .multilineTextAlignment(.trailing)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .trailing) // ✅ Constrain width
                        .padding(.trailing, width/50)
                        .foregroundColor(.white)
                }
        }
    }
}

// MARK: - Best Solution: Using HStack with Spacer
struct OverlayTextWrapFixV3: View {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            Spacer()
            
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .frame(width: width * 2, height: height * 0.2)
                .background(CustomBlurView(effect: .systemUltraThinMaterialDark).opacity(0.6))
                .blur(radius: 25)
                .overlay {
                    // ✅ BEST: Use HStack with Spacer for proper trailing alignment
                    HStack {
                        Spacer()
                        Text("ست پاییزی قهوه‌ای به همراه بوت و کیف چرم")
                            .font(.custom("AbarHighNoEn-SemiBold", size: width/14, relativeTo: .body))
                            .multilineTextAlignment(.trailing)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: width * 1.8) // Constrain width
                            .padding(.trailing, width/50)
                            .foregroundColor(.white)
                    }
                }
        }
    }
}

// MARK: - Using GeometryReader for precise control
struct OverlayTextWrapFixV4: View {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            Spacer()
            
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .frame(width: width * 2, height: height * 0.2)
                .background(CustomBlurView(effect: .systemUltraThinMaterialDark).opacity(0.6))
                .blur(radius: 25)
                .overlay {
                    GeometryReader { geometry in
                        Text("ست پاییزی قهوه‌ای به همراه بوت و کیف چرم")
                            .font(.custom("AbarHighNoEn-SemiBold", size: width/14, relativeTo: .body))
                            .multilineTextAlignment(.trailing)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: geometry.size.width - (width/50) * 2, alignment: .trailing)
                            .padding(.trailing, width/50)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                    }
                }
        }
    }
}

// MARK: - Custom Blur View (if not already defined)
struct CustomBlurView: UIViewRepresentable {
    var effect: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: effect))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// MARK: - Preview
#Preview {
    OverlayTextWrapFixV3()
}


