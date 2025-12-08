//
//  InteractiveImageExample.swift
//  Ready-to-use example of interactive image
//

import SwiftUI

struct InteractiveImageExample: View {
    @State private var showCoordinateFinder = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Example 1: iPhone with interactive regions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Example: iPhone Interactive Image")
                            .font(.title2.bold())
                            .padding(.horizontal)
                        
                        InteractiveImageView(
                            imageName: "iphone",  // Replace with your image
                            regions: createiPhoneRegions(),
                            contentMode: .fit,
                            showHotspots: true,
                            hotspotSize: 50
                        )
                        .frame(height: 500)
                        .padding(.horizontal)
                    }
                    
                    Divider()
                    
                    // Example 2: Product with features
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Example: Product Features")
                            .font(.title2.bold())
                            .padding(.horizontal)
                        
                        InteractiveImageView(
                            imageName: "product",  // Replace with your image
                            regions: createProductRegions(),
                            contentMode: .fit,
                            showHotspots: true
                        )
                        .frame(height: 400)
                        .padding(.horizontal)
                    }
                    
                    // Coordinate Finder Button
                    Button(action: {
                        showCoordinateFinder = true
                    }) {
                        HStack {
                            Image(systemName: "crosshairs")
                            Text("Open Coordinate Finder Tool")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .sheet(isPresented: $showCoordinateFinder) {
                        CoordinateFinderView(imageName: "iphone")
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Interactive Images")
        }
    }
    
    // MARK: - iPhone Regions
    private func createiPhoneRegions() -> [InteractiveRegion] {
        [
            // Camera (top center)
            InteractiveRegion(
                id: "camera",
                title: "Camera System",
                description: "Advanced triple-camera system with 48MP main sensor, Ultra Wide, and Telephoto lenses. Features ProRAW, Night mode, and Cinematic mode.",
                xPercent: 0.5,
                yPercent: 0.12,
                icon: "camera.fill",
                color: .blue,
                action: {
                    print("📷 Camera details tapped")
                    // Navigate to camera details page
                }
            ),
            
            // Screen (center)
            InteractiveRegion(
                id: "screen",
                title: "Super Retina XDR Display",
                description: "6.7-inch OLED display with ProMotion technology (120Hz refresh rate), HDR support, and True Tone.",
                xPercent: 0.5,
                yPercent: 0.45,
                widthPercent: 0.65,
                heightPercent: 0.38,
                icon: "rectangle.on.rectangle",
                color: .green,
                action: {
                    print("📱 Display details tapped")
                }
            ),
            
            // Face ID (bottom center)
            InteractiveRegion(
                id: "faceid",
                title: "Face ID",
                description: "Secure facial recognition technology for authentication and Apple Pay.",
                xPercent: 0.5,
                yPercent: 0.88,
                icon: "faceid",
                color: .purple,
                action: {
                    print("🔒 Face ID details tapped")
                }
            ),
            
            // Volume Up (left side)
            InteractiveRegion(
                id: "volume-up",
                title: "Volume Up",
                description: "Tactile volume control button",
                xPercent: 0.05,
                yPercent: 0.30,
                icon: "speaker.wave.2.fill",
                color: .orange,
                action: {
                    print("🔊 Volume Up tapped")
                }
            ),
            
            // Volume Down (left side)
            InteractiveRegion(
                id: "volume-down",
                title: "Volume Down",
                description: "Tactile volume control button",
                xPercent: 0.05,
                yPercent: 0.40,
                icon: "speaker.wave.1.fill",
                color: .orange,
                action: {
                    print("🔉 Volume Down tapped")
                }
            ),
            
            // Power Button (right side)
            InteractiveRegion(
                id: "power",
                title: "Side Button",
                description: "Power button and Siri activation",
                xPercent: 0.95,
                yPercent: 0.35,
                icon: "power",
                color: .red,
                action: {
                    print("⚡ Power button tapped")
                }
            )
        ]
    }
    
    // MARK: - Product Regions
    private func createProductRegions() -> [InteractiveRegion] {
        [
            InteractiveRegion(
                id: "feature1",
                title: "Premium Material",
                description: "Made with high-quality materials",
                xPercent: 0.3,
                yPercent: 0.3,
                icon: "star.fill",
                color: .yellow,
                action: {
                    print("⭐ Feature 1 tapped")
                }
            ),
            InteractiveRegion(
                id: "feature2",
                title: "Advanced Technology",
                description: "Cutting-edge technology inside",
                xPercent: 0.7,
                yPercent: 0.5,
                icon: "gearshape.fill",
                color: .cyan,
                action: {
                    print("⚙️ Feature 2 tapped")
                }
            ),
            InteractiveRegion(
                id: "feature3",
                title: "Eco-Friendly",
                description: "Environmentally conscious design",
                xPercent: 0.5,
                yPercent: 0.7,
                icon: "leaf.fill",
                color: .green,
                action: {
                    print("🌿 Feature 3 tapped")
                }
            )
        ]
    }
}

// MARK: - Preview
#Preview {
    InteractiveImageExample()
}


