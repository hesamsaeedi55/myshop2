//
//  TabViewImageTracker.swift
//  Example: Track current image in TabView
//

import SwiftUI

struct TabViewImageTracker: View {
    @State private var currentIndex: Int = 0
    
    var body: some View {
        VStack {
            // Display current index
            Text("Current Image: \(currentIndex + 1) / 3")
                .font(.headline)
                .padding()
            
            TabView(selection: $currentIndex) {
                ForEach(0..<3, id: \.self) { index in
                    Image("f7")
                        .resizable()
                        .aspectRatio(9/15, contentMode: .fill)
                        .tag(index) // Important: Tag each view with its index
                }
            }
            .aspectRatio(9/15, contentMode: .fill)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: currentIndex) { oldValue, newValue in
                // This fires whenever the index changes
                print("Image changed from index \(oldValue) to \(newValue)")
            }
        }
    }
}

// MARK: - Alternative: Using GeometryReader for more control
struct TabViewImageTrackerAdvanced: View {
    @State private var currentIndex: Int = 0
    
    var body: some View {
        VStack {
            // Display current index with visual indicator
            HStack {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                }
            }
            .padding()
            
            Text("Image \(currentIndex + 1) is currently visible")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            TabView(selection: $currentIndex) {
                ForEach(0..<3, id: \.self) { index in
                    GeometryReader { geometry in
                        Image("f7")
                            .resizable()
                            .aspectRatio(9/15, contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    }
                    .tag(index)
                }
            }
            .aspectRatio(9/15, contentMode: .fill)
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

// MARK: - With Custom Images Array
struct TabViewWithImageArray: View {
    @State private var currentIndex: Int = 0
    let imageNames = ["f7", "f7", "f7"] // Replace with your actual image names
    
    var body: some View {
        VStack {
            Text("Viewing: \(imageNames[currentIndex]) (Index: \(currentIndex))")
                .font(.caption)
                .padding()
            
            TabView(selection: $currentIndex) {
                ForEach(Array(imageNames.enumerated()), id: \.offset) { index, imageName in
                    Image(imageName)
                        .resizable()
                        .aspectRatio(9/15, contentMode: .fill)
                        .tag(index)
                }
            }
            .aspectRatio(9/15, contentMode: .fill)
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

// MARK: - Preview
#Preview {
    TabViewImageTracker()
}


