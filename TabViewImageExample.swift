import SwiftUI

// MARK: - Correct TabView with Images
struct ImageTabViewExample: View {
    let width: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        TabView {
            // Each image needs to be a separate view/page
            ForEach(0..<3, id: \.self) { index in
                Image("f7")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width)
                    .clipped() // Important: clips overflow
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 350)
    }
}

// MARK: - Alternative: Different Images
struct MultipleImageTabView: View {
    let imageNames = ["f7", "f7", "f7"] // Replace with your actual image names
    let width: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        TabView {
            ForEach(Array(imageNames.enumerated()), id: \.offset) { index, imageName in
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width)
                    .clipped()
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 350)
    }
}

// MARK: - With Page Indicators
struct ImageTabViewWithIndicators: View {
    let width: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        TabView {
            ForEach(0..<3, id: \.self) { index in
                Image("f7")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width)
                    .clipped()
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always)) // Shows page indicators
        .frame(height: 350)
    }
}

// MARK: - With Custom Width
struct ImageTabViewCustom: View {
    @State private var width: CGFloat = 300
    
    var body: some View {
        VStack {
            TabView {
                ForEach(0..<3, id: \.self) { index in
                    Image("f7")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width)
                        .clipped()
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 350)
        }
    }
}

// MARK: - What Was Wrong in Your Code
/*
 ISSUES IN YOUR ORIGINAL CODE:
 
 1. You had an HStack inside TabView - this creates only ONE tab/page
    ❌ TabView {
         HStack {
           ForEach(...) { ... }
         }
       }
 
 2. TabView with .page style needs separate views for each page
    ✅ TabView {
         ForEach(...) { ... }  // Each iteration creates a new page
       }
 
 3. The `_` in ForEach ignores the index, so you can't differentiate images
    ❌ ForEach(0...2, id: \.self) { _ in
    ✅ ForEach(0..<3, id: \.self) { index in
 
 4. Missing .clipped() - images might overflow the frame
    ✅ .clipped() after .frame()
 */

// MARK: - Auto-Sizing TabView (No Fixed Dimensions)
struct AutoSizingImageTabView: View {
    var body: some View {
        TabView {
            ForEach(0..<3, id: \.self) { index in
                Image("f7")
                    .resizable()
                    .aspectRatio(contentMode: .fit) // Maintains aspect ratio
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        // No fixed frame - sizes based on parent container
    }
}

// MARK: - Using GeometryReader for Natural Sizing
struct NaturalSizingTabView: View {
    var body: some View {
        GeometryReader { geometry in
            TabView {
                ForEach(0..<3, id: \.self) { index in
                    Image("f7")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .aspectRatio(16/9, contentMode: .fit) // Optional: maintain aspect ratio
    }
}

// MARK: - Container-Based Auto Sizing
struct ContainerBasedTabView: View {
    var body: some View {
        VStack {
            TabView {
                ForEach(0..<3, id: \.self) { index in
                    Image("f7")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .frame(maxWidth: .infinity) // Takes available width
        .aspectRatio(1.0, contentMode: .fit) // Square, or use 16/9 for widescreen
    }
}

// MARK: - Why Your Code Shows Nothing
/*
 THE PROBLEM:
 
 1. TabView needs a height constraint to display
    - Without height, it collapses to zero height
    - Even with .fit, if there's no height constraint, it can't calculate size
 
 2. .aspectRatio(contentMode: .fit) makes image fit within frame
    - If frame has no height, image has no size to fit into
    - Result: nothing visible
 
 SOLUTIONS:
 
 Option 1: Use GeometryReader (recommended for flexible sizing)
    GeometryReader provides available space
    TabView can then size itself within that space
 
 Option 2: Use aspectRatio modifier on TabView
    .aspectRatio(16/9, contentMode: .fit)
    This gives TabView a natural size based on aspect ratio
 
 Option 3: Put in container with constraints
    VStack/HStack with maxWidth/maxHeight
    TabView sizes to container
 */

// MARK: - Your Fixed Code (Full Width)
struct YourFixedTabView: View {
    var body: some View {
        TabView {
            ForEach(0..<3, id: \.self) { index in
                Image("f7")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(maxWidth: .infinity) // Takes full width
        .aspectRatio(16/9, contentMode: .fit) // Maintains aspect ratio
    }
}

// MARK: - Alternative: Full Width with GeometryReader
struct FullWidthTabView: View {
    var body: some View {
        GeometryReader { geometry in
            TabView {
                ForEach(0..<3, id: \.self) { index in
                    Image("f7")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .aspectRatio(16/9, contentMode: .fit)
    }
}

// MARK: - WORKING Full Width Solution
struct WorkingFullWidthTabView: View {
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = width * 9 / 16 // 16:9 aspect ratio
            
            TabView {
                ForEach(0..<3, id: \.self) { index in
                    Image("f7")
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                        .clipped()
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(width: width, height: height)
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(16/9, contentMode: .fit)
    }
}

// MARK: - Natural Image Size (No Manipulation) - WORKING
struct NaturalImageTabView: View {
    var body: some View {
        GeometryReader { geometry in
            TabView {
                ForEach(0..<3, id: \.self) { index in
                    Image("f7")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Alternative: Using PreferenceKey to get image height
struct AutoHeightTabView: View {
    @State private var imageHeight: CGFloat = 0
    
    var body: some View {
        TabView {
            ForEach(0..<3, id: \.self) { index in
                Image("f7")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .preference(key: ImageHeightKey.self, value: geo.size.height)
                        }
                    )
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(maxWidth: .infinity)
        .frame(height: imageHeight > 0 ? imageHeight : nil)
        .onPreferenceChange(ImageHeightKey.self) { height in
            imageHeight = height
        }
    }
}

struct ImageHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Alternative: Using GeometryReader (Most Reliable)
struct ReliableFullWidthTabView: View {
    var body: some View {
        GeometryReader { geometry in
            TabView {
                ForEach(0..<3, id: \.self) { index in
                    Image("f7")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width, height: geometry.size.width * 9/16)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .aspectRatio(16/9, contentMode: .fit)
    }
}

// MARK: - What Was Wrong
/*
 YOUR CODE PROBLEMS:
 
 1. Image missing aspectRatio constraint:
    ❌ Image("f7").resizable()  // Stretches/deforms!
    ✅ Image("f7").resizable().scaledToFit()  // Maintains aspect ratio
 
 2. maxHeight conflicts with aspectRatio:
    ❌ .frame(maxWidth: .infinity, maxHeight: .infinity)
       .aspectRatio(16/9, contentMode: .fit)  // Conflicts!
    ✅ .frame(maxWidth: .infinity)
       .aspectRatio(16/9, contentMode: .fit)  // Height calculated from width
 
 3. Use scaledToFit() on image to prevent deformation
 */

// MARK: - GUARANTEED Full Width Solution (Works in Any Container)
struct GuaranteedFullWidthTabView: View {
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = UIScreen.main.bounds.width
            
            TabView {
                ForEach(0..<3, id: \.self) { index in
                    Image("f7")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth)  // Explicit screen width
                        .frame(maxWidth: .infinity) // Also set maxWidth
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(width: screenWidth)  // Force TabView width
            .frame(maxWidth: .infinity) // Also set maxWidth
        }
        .frame(maxWidth: .infinity)  // Fill parent width
        .ignoresSafeArea(.container, edges: .horizontal)  // Remove horizontal padding
    }
}

// MARK: - Alternative: Using Screen Width Directly (Simplest)
struct SimpleFullWidthTabView: View {
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        TabView {
            ForEach(0..<3, id: \.self) { index in
                Image("f7")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: screenWidth)
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(.container, edges: .horizontal)
    }
}

// MARK: - Preview
struct TabViewImageExample_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            ImageTabViewExample()
                .previewDisplayName("Basic Example")
            
            AutoSizingImageTabView()
                .previewDisplayName("Auto-Sizing")
            
            YourFixedTabView()
                .previewDisplayName("Your Fixed Code")
            
            GuaranteedFullWidthTabView()
                .previewDisplayName("Guaranteed Full Width")
        }
    }
}

