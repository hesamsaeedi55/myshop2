# Interactive Image Guide

## Overview

This guide explains how to create interactive images with precise tap regions that work across all device sizes. The system uses **percentage-based coordinates** (0.0 to 1.0) instead of absolute pixels, making it fully responsive.

## Key Concepts

### Percentage-Based Coordinates

Instead of using absolute pixel positions (like `x: 200, y: 300`), we use percentages:
- **xPercent**: 0.0 (left edge) to 1.0 (right edge)
- **yPercent**: 0.0 (top edge) to 1.0 (bottom edge)

This ensures buttons stay in the correct position regardless of:
- Screen size (iPhone SE to iPad Pro)
- Image aspect ratio
- Device orientation

### Example: iPhone Image

Imagine an iPhone image. To place a button on the camera (top center):
- **xPercent: 0.5** (center horizontally)
- **yPercent: 0.12** (near the top, about 12% down)

## Quick Start

### 1. Basic Usage

```swift
InteractiveImageView(
    imageName: "iphone",  // Your image name
    regions: [
        InteractiveRegion(
            id: "camera",
            title: "Camera System",
            description: "Triple camera with ProRAW",
            xPercent: 0.5,   // Center X
            yPercent: 0.12,  // Near top
            icon: "camera.fill",
            color: .blue,
            action: {
                // Navigate to camera details
                print("Camera tapped!")
            }
        )
    ],
    contentMode: .fit,
    showHotspots: true
)
.frame(height: 500)
```

### 2. Finding Coordinates

#### Method 1: Use Coordinate Finder Tool

```swift
// Add this to your app for testing
CoordinateFinderView(imageName: "your-image-name")
```

1. Load your image in `CoordinateFinderView`
2. Tap on the areas where you want buttons
3. Copy the generated coordinates
4. Use them in your `InteractiveImageView`

#### Method 2: Manual Calculation

If you know the pixel coordinates from a design tool (like Figma, Sketch):

```
xPercent = pixelX / imageWidth
yPercent = pixelY / imageHeight
```

**Example:**
- Image is 1000px wide, 2000px tall
- Camera is at pixel (500, 240)
- xPercent = 500 / 1000 = 0.5
- yPercent = 240 / 2000 = 0.12

### 3. Custom Region Sizes

By default, regions are circular with size `hotspotSize`. You can specify custom sizes:

```swift
InteractiveRegion(
    id: "screen",
    title: "Display",
    xPercent: 0.5,
    yPercent: 0.45,
    widthPercent: 0.6,   // 60% of image width
    heightPercent: 0.35, // 35% of image height
    icon: "rectangle",
    color: .green,
    action: { }
)
```

## Real-World Example: iPhone Interactive Image

```swift
struct iPhoneInteractiveView: View {
    var body: some View {
        InteractiveImageView(
            imageName: "iphone-15-pro",
            regions: [
                // Camera (top center)
                InteractiveRegion(
                    id: "camera",
                    title: "Camera System",
                    description: "48MP Main, Ultra Wide, Telephoto",
                    xPercent: 0.5,
                    yPercent: 0.12,
                    icon: "camera.fill",
                    color: .blue,
                    action: {
                        // Navigate to camera page
                        navigateToCameraDetails()
                    }
                ),
                
                // Screen (center)
                InteractiveRegion(
                    id: "screen",
                    title: "Super Retina XDR",
                    description: "6.7-inch OLED with ProMotion",
                    xPercent: 0.5,
                    yPercent: 0.45,
                    widthPercent: 0.65,
                    heightPercent: 0.38,
                    icon: "rectangle.on.rectangle",
                    color: .green,
                    action: {
                        navigateToDisplayDetails()
                    }
                ),
                
                // Face ID (bottom center)
                InteractiveRegion(
                    id: "faceid",
                    title: "Face ID",
                    description: "Secure facial recognition",
                    xPercent: 0.5,
                    yPercent: 0.88,
                    icon: "faceid",
                    color: .purple,
                    action: {
                        navigateToSecurityDetails()
                    }
                ),
                
                // Volume Up (left side, top)
                InteractiveRegion(
                    id: "volume-up",
                    title: "Volume Up",
                    xPercent: 0.05,
                    yPercent: 0.30,
                    icon: "speaker.wave.2.fill",
                    color: .orange,
                    action: { }
                ),
                
                // Volume Down (left side, bottom)
                InteractiveRegion(
                    id: "volume-down",
                    title: "Volume Down",
                    xPercent: 0.05,
                    yPercent: 0.40,
                    icon: "speaker.wave.1.fill",
                    color: .orange,
                    action: { }
                ),
                
                // Power Button (right side)
                InteractiveRegion(
                    id: "power",
                    title: "Side Button",
                    description: "Power and Siri",
                    xPercent: 0.95,
                    yPercent: 0.35,
                    icon: "power",
                    color: .red,
                    action: { }
                )
            ],
            contentMode: .fit,
            showHotspots: true,
            hotspotSize: 50
        )
    }
}
```

## Tips for Precise Positioning

### 1. Use Design Tools

- Open your image in Figma/Sketch/Photoshop
- Note the pixel coordinates of features
- Convert to percentages using the formula above

### 2. Test on Multiple Devices

The percentage system works across devices, but test to ensure:
- Buttons aren't too close to edges
- Touch targets are large enough (minimum 44x44 points)
- Overlapping regions don't interfere

### 3. Account for Image Aspect Ratio

If your image has a different aspect ratio than the container:
- Use `contentMode: .fit` to maintain aspect ratio
- Coordinates are relative to the **rendered image size**, not container
- The component automatically handles this

### 4. Handle Different Orientations

For landscape/portrait support:
```swift
@State private var isLandscape = false

// In your view
.onChange(of: geometry.size) { newSize in
    isLandscape = newSize.width > newSize.height
}

// Adjust regions based on orientation if needed
let regions = isLandscape ? landscapeRegions : portraitRegions
```

## Advanced: Dynamic Regions

You can load regions from a data source:

```swift
struct ProductInteractiveView: View {
    let product: Product
    @State private var regions: [InteractiveRegion] = []
    
    var body: some View {
        InteractiveImageView(
            imageName: product.imageName,
            regions: regions,
            contentMode: .fit
        )
        .onAppear {
            loadRegions()
        }
    }
    
    private func loadRegions() {
        // Load from API or database
        regions = product.features.map { feature in
            InteractiveRegion(
                id: feature.id,
                title: feature.name,
                description: feature.description,
                xPercent: feature.xPercent,
                yPercent: feature.yPercent,
                icon: feature.icon,
                color: feature.color,
                action: {
                    navigateToFeature(feature)
                }
            )
        }
    }
}
```

## Troubleshooting

### Buttons Not Aligned Correctly

1. **Check coordinate system**: Ensure you're using 0.0-1.0 range
2. **Verify image aspect ratio**: Use `contentMode: .fit` for consistent scaling
3. **Test on actual device**: Simulator may have different rendering

### Buttons Too Small/Large

- Adjust `hotspotSize` parameter (default: 44)
- Or use `widthPercent` and `heightPercent` for custom sizes

### Performance Issues

- Limit number of regions (recommended: < 10)
- Use `AsyncImage` for remote images
- Consider lazy loading for complex images

## Best Practices

1. **Minimum Touch Target**: Keep regions at least 44x44 points
2. **Visual Feedback**: Use `showHotspots: true` during development
3. **Accessibility**: Add meaningful titles and descriptions
4. **Testing**: Test on multiple device sizes
5. **Error Handling**: Handle image loading failures gracefully

## Integration with Navigation

```swift
struct ProductDetailView: View {
    @State private var selectedFeature: Feature?
    
    var body: some View {
        NavigationStack {
            InteractiveImageView(
                imageName: "product",
                regions: createRegions(),
                contentMode: .fit
            )
            .navigationDestination(item: $selectedFeature) { feature in
                FeatureDetailView(feature: feature)
            }
        }
    }
    
    private func createRegions() -> [InteractiveRegion] {
        [
            InteractiveRegion(
                id: "feature1",
                title: "Feature 1",
                xPercent: 0.3,
                yPercent: 0.4,
                action: {
                    selectedFeature = Feature(id: "feature1")
                }
            )
        ]
    }
}
```

## Summary

- ✅ Use percentage coordinates (0.0 to 1.0) for responsiveness
- ✅ Use `CoordinateFinderView` to find coordinates visually
- ✅ Test on multiple devices
- ✅ Keep touch targets at least 44x44 points
- ✅ Use meaningful titles and descriptions for accessibility

The system automatically handles:
- Different screen sizes
- Image aspect ratios
- Device orientations (with proper setup)
- Visual feedback and animations


