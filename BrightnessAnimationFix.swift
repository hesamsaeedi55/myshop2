//
//  BrightnessAnimationFix.swift
//  Fix: index variable not found in TabView
//

import SwiftUI

// MARK: - ✅ CORRECT: Using ForEach with indices
struct BrightnessAnimationCorrect: View {
    @State private var selectIndex: Int = 0
    let images = ["f7", "f7", "f7"] // Your image array
    
    var body: some View {
        VStack {
            TabView(selection: $selectIndex) {
                ForEach(images.indices, id: \.self) { index in
                    Image(images[index])
                        .resizable()
                        .brightness(index == selectIndex ? 0 : -0.1)
                        .animation(.spring(response: 0.8, dampingFraction: 0.5), value: selectIndex)
                        .tag(index) // ✅ Important: Tag each view
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            Text("Selected: \(selectIndex)")
        }
    }
}

// MARK: - ✅ CORRECT: Using range with ForEach
struct BrightnessAnimationCorrectV2: View {
    @State private var selectIndex: Int = 0
    
    var body: some View {
        VStack {
            TabView(selection: $selectIndex) {
                ForEach(0..<3, id: \.self) { index in
                    Image("f7")
                        .resizable()
                        .brightness(index == selectIndex ? 0 : -0.1)
                        .animation(.spring(response: 0.8, dampingFraction: 0.5), value: selectIndex)
                        .tag(index) // ✅ Important: Tag each view
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            Text("Selected: \(selectIndex)")
        }
    }
}

// MARK: - ✅ CORRECT: Using enumerated() with array
struct BrightnessAnimationCorrectV3: View {
    @State private var selectIndex: Int = 0
    let images = ["f7", "f7", "f7"]
    
    var body: some View {
        VStack {
            TabView(selection: $selectIndex) {
                ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                    Image(image)
                        .resizable()
                        .brightness(index == selectIndex ? 0 : -0.1)
                        .animation(.spring(response: 0.8, dampingFraction: 0.5), value: selectIndex)
                        .tag(index) // ✅ Important: Tag each view
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            Text("Selected: \(selectIndex)")
        }
    }
}

// MARK: - ❌ WRONG: Missing ForEach iteration
struct BrightnessAnimationWrong: View {
    @State private var selectIndex: Int = 0
    let images = ["f7", "f7", "f7"]
    
    var body: some View {
        VStack {
            TabView(selection: $selectIndex) {
                // ❌ This won't work - no index variable!
                Image("f7")
                    .resizable()
                    .brightness(index == selectIndex ? 0 : -0.1) // ❌ ERROR: Cannot find 'index'
            }
        }
    }
}

// MARK: - ✅ COMPLETE EXAMPLE: With proper structure
struct CompleteBrightnessExample: View {
    @State private var selectIndex: Int = 0
    let imageNames = ["f7", "f7", "f7"] // Replace with your actual images
    
    var body: some View {
        VStack {
            TabView(selection: $selectIndex) {
                ForEach(imageNames.indices, id: \.self) { index in
                    Image(imageNames[index])
                        .resizable()
                        .aspectRatio(9/15, contentMode: .fill)
                        .brightness(index == selectIndex ? 0 : -0.1)
                        .animation(.spring(response: 0.8, dampingFraction: 0.5), value: selectIndex)
                        .tag(index)
                }
            }
            .aspectRatio(9/15, contentMode: .fill)
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            Text("Current Index: \(selectIndex)")
        }
    }
}

// MARK: - Preview
#Preview {
    CompleteBrightnessExample()
}


