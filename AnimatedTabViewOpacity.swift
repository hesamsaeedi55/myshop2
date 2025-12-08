//
//  AnimatedTabViewOpacity.swift
//  Example: Animate opacity in TabView
//

import SwiftUI

struct AnimatedTabViewOpacity: View {
    @State private var selectIndex: Int = 0
    
    var body: some View {
        VStack {
            // Suggestions Header
            TabView(selection: $selectIndex) {
                ForEach(0..<3, id: \.self) { index in
                    VStack {
                        Image("f7")
                            .resizable()
                            .opacity(index == selectIndex ? 1 : 0.4)
                            .animation(.easeInOut(duration: 0.3), value: selectIndex) // ✅ Add animation here
                    }
                    .tag(index) // Important: Tag each view
                }
            }
            .aspectRatio(9/15, contentMode: .fill)
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            Text("\(selectIndex)")
        }
    }
}

// MARK: - Alternative: Using withAnimation in onChange
struct AnimatedTabViewOpacityV2: View {
    @State private var selectIndex: Int = 0
    
    var body: some View {
        VStack {
            TabView(selection: $selectIndex) {
                ForEach(0..<3, id: \.self) { index in
                    VStack {
                        Image("f7")
                            .resizable()
                            .opacity(index == selectIndex ? 1 : 0.4)
                    }
                    .tag(index)
                }
            }
            .aspectRatio(9/15, contentMode: .fill)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: selectIndex) { oldValue, newValue in
                // Animate when index changes
                withAnimation(.easeInOut(duration: 0.3)) {
                    // The opacity will animate automatically
                }
            }
            
            Text("\(selectIndex)")
        }
    }
}

// MARK: - With Custom Animation Curve
struct AnimatedTabViewOpacityV3: View {
    @State private var selectIndex: Int = 0
    
    var body: some View {
        VStack {
            TabView(selection: $selectIndex) {
                ForEach(0..<3, id: \.self) { index in
                    VStack {
                        Image("f7")
                            .resizable()
                            .opacity(index == selectIndex ? 1 : 0.4)
                            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectIndex) // Spring animation
                    }
                    .tag(index)
                }
            }
            .aspectRatio(9/15, contentMode: .fill)
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            Text("\(selectIndex)")
        }
    }
}

// MARK: - With Scale Effect Too
struct AnimatedTabViewWithScale: View {
    @State private var selectIndex: Int = 0
    
    var body: some View {
        VStack {
            TabView(selection: $selectIndex) {
                ForEach(0..<3, id: \.self) { index in
                    VStack {
                        Image("f7")
                            .resizable()
                            .opacity(index == selectIndex ? 1 : 0.4)
                            .scaleEffect(index == selectIndex ? 1.0 : 0.95)
                            .animation(.easeInOut(duration: 0.3), value: selectIndex)
                    }
                    .tag(index)
                }
            }
            .aspectRatio(9/15, contentMode: .fill)
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            Text("\(selectIndex)")
        }
    }
}

// MARK: - Preview
#Preview {
    AnimatedTabViewOpacity()
}


