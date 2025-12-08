//
//  CoordinateFinderView.swift
//  Tool to Find Precise Coordinates on Images
//
//  This view helps you determine the exact percentage coordinates
//  (xPercent, yPercent) for placing interactive regions on your images.
//

import SwiftUI

struct CoordinateFinderView: View {
    let imageName: String
    let imageURL: String?
    
    @State private var tapPoints: [CGPoint] = []
    @State private var showCoordinates: Bool = true
    @State private var imageSize: CGSize = .zero
    @State private var containerSize: CGSize = .zero
    
    init(imageName: String = "", imageURL: String? = nil) {
        self.imageName = imageName
        self.imageURL = imageURL
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Image with coordinate overlay
                GeometryReader { geometry in
                    ZStack {
                        // Base image
                        Group {
                            if let urlString = imageURL, !urlString.isEmpty {
                                AsyncImage(url: URL(string: urlString)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            } else if !imageName.isEmpty {
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .overlay(
                                        Text("Load an image to find coordinates")
                                            .foregroundColor(.gray)
                                    )
                            }
                        }
                        .background(
                            GeometryReader { imageGeometry in
                                Color.clear
                                    .onAppear {
                                        updateSizes(container: geometry.size, image: imageGeometry.size)
                                    }
                                    .onChange(of: geometry.size) { newSize in
                                        updateSizes(container: newSize, image: imageGeometry.size)
                                    }
                            }
                        )
                        
                        // Tap indicators
                        ForEach(Array(tapPoints.enumerated()), id: \.offset) { index, point in
                            let percentX = point.x / containerSize.width
                            let percentY = point.y / containerSize.height
                            
                            ZStack {
                                // Circle indicator
                                Circle()
                                    .fill(Color.blue.opacity(0.3))
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.blue, lineWidth: 2)
                                    )
                                
                                // Number label
                                Text("\(index + 1)")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.blue)
                            }
                            .position(point)
                            
                            // Coordinate label
                            if showCoordinates {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Point \(index + 1)")
                                        .font(.caption.bold())
                                    Text("X: \(percentX, specifier: "%.3f")")
                                        .font(.caption.monospaced())
                                    Text("Y: \(percentY, specifier: "%.3f")")
                                        .font(.caption.monospaced())
                                }
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.ultraThinMaterial)
                                        .shadow(radius: 4)
                                )
                                .offset(x: point.x < containerSize.width / 2 ? 40 : -40,
                                       y: point.y < containerSize.height / 2 ? 40 : -40)
                            }
                        }
                    }
                    .onTapGesture { location in
                        withAnimation {
                            tapPoints.append(location)
                        }
                    }
                    .onAppear {
                        containerSize = geometry.size
                    }
                    .onChange(of: geometry.size) { newSize in
                        containerSize = newSize
                    }
                }
                
                // Control panel
                VStack(spacing: 16) {
                    // Instructions
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Instructions:")
                            .font(.headline)
                        Text("• Tap anywhere on the image to mark a point")
                        Text("• Coordinates are shown as percentages (0.0 to 1.0)")
                        Text("• Use these values for xPercent and yPercent")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Coordinate list
                    if !tapPoints.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Coordinates:")
                                    .font(.headline)
                                
                                ForEach(Array(tapPoints.enumerated()), id: \.offset) { index, point in
                                    let percentX = point.x / containerSize.width
                                    let percentY = point.y / containerSize.height
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Point \(index + 1)")
                                            .font(.subheadline.bold())
                                        
                                        CodeBlock(text: """
InteractiveRegion(
    id: "point\(index + 1)",
    title: "Feature \(index + 1)",
    xPercent: \(String(format: "%.3f", percentX)),
    yPercent: \(String(format: "%.3f", percentY)),
    icon: "circle.fill",
    color: .blue,
    action: {
        // Your action here
    }
)
""")
                                    }
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .cornerRadius(8)
                                }
                            }
                            .padding()
                        }
                        .frame(maxHeight: 300)
                    }
                    
                    // Action buttons
                    HStack(spacing: 12) {
                        Button(action: {
                            withAnimation {
                                tapPoints.removeLast()
                            }
                        }) {
                            Label("Remove Last", systemImage: "arrow.uturn.backward")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange.opacity(0.2))
                                .foregroundColor(.orange)
                                .cornerRadius(10)
                        }
                        .disabled(tapPoints.isEmpty)
                        
                        Button(action: {
                            withAnimation {
                                tapPoints.removeAll()
                            }
                        }) {
                            Label("Clear All", systemImage: "trash")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.2))
                                .foregroundColor(.red)
                                .cornerRadius(10)
                        }
                        .disabled(tapPoints.isEmpty)
                        
                        Button(action: {
                            showCoordinates.toggle()
                        }) {
                            Label(showCoordinates ? "Hide" : "Show", systemImage: showCoordinates ? "eye.slash" : "eye")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
            }
            .navigationTitle("Coordinate Finder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        copyAllCoordinates()
                    }) {
                        Image(systemName: "doc.on.doc")
                    }
                    .disabled(tapPoints.isEmpty)
                }
            }
        }
    }
    
    private func updateSizes(container: CGSize, image: CGSize) {
        containerSize = container
        imageSize = image
    }
    
    private func copyAllCoordinates() {
        var code = "// Interactive Regions:\n"
        for (index, point) in tapPoints.enumerated() {
            let percentX = point.x / containerSize.width
            let percentY = point.y / containerSize.height
            code += """
InteractiveRegion(
    id: "region\(index + 1)",
    title: "Region \(index + 1)",
    xPercent: \(String(format: "%.3f", percentX)),
    yPercent: \(String(format: "%.3f", percentY)),
    icon: "circle.fill",
    color: .blue,
    action: {
        // Action for region \(index + 1)
    }
),
"""
            if index < tapPoints.count - 1 {
                code += "\n"
            }
        }
        
        UIPasteboard.general.string = code
    }
}

// MARK: - Code Block View
struct CodeBlock: View {
    let text: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            Text(text)
                .font(.system(.caption, design: .monospaced))
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(.systemGray5))
        .cornerRadius(6)
    }
}

// MARK: - Preview
#Preview {
    CoordinateFinderView(imageName: "iphone")
}

