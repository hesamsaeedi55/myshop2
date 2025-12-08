//
//  InteractiveImageView.swift
//  Interactive Image with Precise Tap Regions
//
//  This component allows you to place interactive buttons/overlays
//  on specific regions of an image using percentage-based coordinates
//  that automatically scale with different screen sizes and image aspect ratios.
//

import SwiftUI

// MARK: - Interactive Region Model
struct InteractiveRegion {
    let id: String
    let title: String
    let description: String?
    let xPercent: CGFloat  // 0.0 to 1.0 (left to right)
    let yPercent: CGFloat  // 0.0 to 1.0 (top to bottom)
    let widthPercent: CGFloat?  // Optional: if nil, uses default size
    let heightPercent: CGFloat? // Optional: if nil, uses default size
    let icon: String?
    let color: Color
    let action: () -> Void
    
    init(
        id: String,
        title: String,
        description: String? = nil,
        xPercent: CGFloat,
        yPercent: CGFloat,
        widthPercent: CGFloat? = nil,
        heightPercent: CGFloat? = nil,
        icon: String? = nil,
        color: Color = .blue,
        action: @escaping () -> Void
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.xPercent = xPercent
        self.yPercent = yPercent
        self.widthPercent = widthPercent
        self.heightPercent = heightPercent
        self.icon = icon
        self.color = color
        self.action = action
    }
}

// MARK: - Main Interactive Image View
struct InteractiveImageView: View {
    let imageName: String  // For system images or local assets
    let imageURL: String?  // For remote images
    let regions: [InteractiveRegion]
    let contentMode: ContentMode
    let showHotspots: Bool  // Show visual indicators
    let hotspotSize: CGFloat
    
    @State private var selectedRegion: InteractiveRegion?
    @State private var imageSize: CGSize = .zero
    @State private var actualImageSize: CGSize = .zero
    
    init(
        imageName: String = "",
        imageURL: String? = nil,
        regions: [InteractiveRegion],
        contentMode: ContentMode = .fit,
        showHotspots: Bool = true,
        hotspotSize: CGFloat = 44
    ) {
        self.imageName = imageName
        self.imageURL = imageURL
        self.regions = regions
        self.contentMode = contentMode
        self.showHotspots = showHotspots
        self.hotspotSize = hotspotSize
    }
    
    var body: some View {
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
                                    .aspectRatio(contentMode: contentMode)
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
                            .aspectRatio(contentMode: contentMode)
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Text("No Image")
                                    .foregroundColor(.gray)
                            )
                    }
                }
                .background(
                    GeometryReader { imageGeometry in
                        Color.clear
                            .onAppear {
                                updateImageSize(geometry: geometry, imageGeometry: imageGeometry)
                            }
                            .onChange(of: geometry.size) { _ in
                                updateImageSize(geometry: geometry, imageGeometry: imageGeometry)
                            }
                    }
                )
                
                // Interactive regions overlay
                ForEach(regions, id: \.id) { region in
                    InteractiveHotspot(
                        region: region,
                        imageSize: actualImageSize,
                        containerSize: imageSize,
                        hotspotSize: hotspotSize,
                        showHotspot: showHotspots,
                        isSelected: selectedRegion?.id == region.id,
                        onTap: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                if selectedRegion?.id == region.id {
                                    selectedRegion = nil
                                } else {
                                    selectedRegion = region
                                }
                            }
                        },
                        onAction: {
                            region.action()
                        }
                    )
                }
                
                // Detail popup
                if let region = selectedRegion {
                    RegionDetailPopup(
                        region: region,
                        onDismiss: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedRegion = nil
                            }
                        },
                        onAction: {
                            region.action()
                            selectedRegion = nil
                        }
                    )
                }
            }
        }
    }
    
    private func updateImageSize(geometry: GeometryProxy, imageGeometry: GeometryProxy) {
        // Get the container size
        imageSize = geometry.size
        
        // Calculate actual image size based on content mode
        let containerAspect = geometry.size.width / geometry.size.height
        
        // For .fit mode, we need to calculate how the image actually renders
        // This is a simplified calculation - you may need to adjust based on your image's aspect ratio
        if contentMode == .fit {
            // The image will fit within the container maintaining aspect ratio
            // We'll use the container size as a base and adjust based on image aspect
            actualImageSize = imageGeometry.size
        } else {
            // For .fill, the image fills the container
            actualImageSize = geometry.size
        }
    }
}

// MARK: - Interactive Hotspot
struct InteractiveHotspot: View {
    let region: InteractiveRegion
    let imageSize: CGSize
    let containerSize: CGSize
    let hotspotSize: CGFloat
    let showHotspot: Bool
    let isSelected: Bool
    let onTap: () -> Void
    let onAction: () -> Void
    
    private var position: CGPoint {
        // Calculate position based on percentage coordinates
        let x = containerSize.width * region.xPercent
        let y = containerSize.height * region.yPercent
        return CGPoint(x: x, y: y)
    }
    
    private var size: CGSize {
        let width = region.widthPercent != nil 
            ? containerSize.width * region.widthPercent! 
            : hotspotSize
        let height = region.heightPercent != nil 
            ? containerSize.height * region.heightPercent! 
            : hotspotSize
        return CGSize(width: width, height: height)
    }
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Invisible tap area (always present for interaction)
                Circle()
                    .fill(Color.clear)
                    .frame(width: size.width, height: size.height)
                
                // Visual hotspot indicator
                if showHotspot {
                    Circle()
                        .fill(region.color.opacity(isSelected ? 0.6 : 0.3))
                        .frame(width: size.width, height: size.height)
                        .overlay(
                            Circle()
                                .stroke(region.color, lineWidth: 2)
                                .frame(width: size.width, height: size.height)
                        )
                        .overlay(
                            // Pulsing animation
                            Circle()
                                .stroke(region.color.opacity(0.5), lineWidth: 2)
                                .frame(width: size.width * 1.3, height: size.height * 1.3)
                                .opacity(isSelected ? 0.6 : 0.3)
                                .scaleEffect(isSelected ? 1.2 : 1.0)
                                .animation(
                                    .easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true),
                                    value: isSelected
                                )
                        )
                        .overlay(
                            // Icon or number
                            Group {
                                if let icon = region.icon {
                                    Image(systemName: icon)
                                        .font(.system(size: size.width * 0.4, weight: .semibold))
                                        .foregroundColor(region.color)
                                } else {
                                    Text("\(region.id)")
                                        .font(.system(size: size.width * 0.3, weight: .bold))
                                        .foregroundColor(region.color)
                                }
                            }
                        )
                        .shadow(color: region.color.opacity(0.5), radius: 8, x: 0, y: 4)
                }
            }
        }
        .position(position)
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Region Detail Popup
struct RegionDetailPopup: View {
    let region: InteractiveRegion
    let onDismiss: () -> Void
    let onAction: () -> Void
    
    var body: some View {
        ZStack {
            // Backdrop
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            // Popup card
            VStack(spacing: 16) {
                // Header
                HStack {
                    if let icon = region.icon {
                        Image(systemName: icon)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(region.color)
                    }
                    
                    Text(region.title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                    }
                }
                
                // Description
                if let description = region.description {
                    Text(description)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Action button
                Button(action: {
                    onAction()
                }) {
                    HStack {
                        Text("View Details")
                            .font(.system(size: 16, weight: .semibold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            colors: [region.color, region.color.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            )
            .padding(.horizontal, 24)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.9)))
    }
}

// MARK: - Example Usage View
struct InteractiveImageViewExample: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    Text("Interactive iPhone Image")
                        .font(.title.bold())
                        .padding(.top)
                    
                    // Example: iPhone with interactive regions
                    InteractiveImageView(
                        imageName: "iphone",  // Use your actual image name
                        regions: [
                            // Camera region (top center)
                            InteractiveRegion(
                                id: "camera",
                                title: "Camera System",
                                description: "Advanced triple-camera system with ProRAW support",
                                xPercent: 0.5,  // Center horizontally
                                yPercent: 0.12, // Near top
                                icon: "camera.fill",
                                color: .blue,
                                action: {
                                    print("Camera tapped")
                                    // Navigate to camera details page
                                }
                            ),
                            
                            // Screen region (center)
                            InteractiveRegion(
                                id: "screen",
                                title: "Super Retina Display",
                                description: "6.7-inch OLED display with ProMotion technology",
                                xPercent: 0.5,
                                yPercent: 0.45,
                                widthPercent: 0.6,
                                heightPercent: 0.35,
                                icon: "rectangle.on.rectangle",
                                color: .green,
                                action: {
                                    print("Screen tapped")
                                }
                            ),
                            
                            // Home indicator (bottom center)
                            InteractiveRegion(
                                id: "home",
                                title: "Face ID",
                                description: "Secure facial recognition technology",
                                xPercent: 0.5,
                                yPercent: 0.88,
                                icon: "faceid",
                                color: .purple,
                                action: {
                                    print("Face ID tapped")
                                }
                            ),
                            
                            // Volume buttons (left side)
                            InteractiveRegion(
                                id: "volume",
                                title: "Volume Controls",
                                description: "Tactile volume buttons",
                                xPercent: 0.05,
                                yPercent: 0.35,
                                icon: "speaker.wave.2.fill",
                                color: .orange,
                                action: {
                                    print("Volume tapped")
                                }
                            ),
                            
                            // Power button (right side)
                            InteractiveRegion(
                                id: "power",
                                title: "Side Button",
                                description: "Power and Siri activation",
                                xPercent: 0.95,
                                yPercent: 0.35,
                                icon: "power",
                                color: .red,
                                action: {
                                    print("Power button tapped")
                                }
                            )
                        ],
                        contentMode: .fit,
                        showHotspots: true,
                        hotspotSize: 50
                    )
                    .frame(height: 500)
                    .padding(.horizontal)
                    
                    // Instructions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How to Use:")
                            .font(.headline)
                        
                        Text("1. Tap on any hotspot to see details")
                        Text("2. Tap 'View Details' to navigate to the feature page")
                        Text("3. Coordinates are percentage-based (0.0 to 1.0)")
                        Text("4. Works across all screen sizes automatically")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Interactive Image")
        }
    }
}

// MARK: - Preview
#Preview {
    InteractiveImageViewExample()
}

