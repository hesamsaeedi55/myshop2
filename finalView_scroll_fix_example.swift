// Example solution for tracking "محصولات مشابه" section visibility
// Add these to your finalView struct:

// 1. Add this preference key (add it outside your struct, at the bottom of the file)
struct SimilarProductsPositionKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// 2. Add this state variable to your finalView struct's state variables:
// @State private var similarProductsPosition: CGFloat = 0

// 3. Update your "محصولات مشابه" section like this:
/*
HStack {
    Spacer()
    Text("محصولات مشابه")
        .font(.custom("AbarHighNoEn-SemiBold", size: 16, relativeTo: .body))
        .multilineTextAlignment(.center)
        .padding(8)
    Spacer()
}
.background(
    GeometryReader { geo in
        Color.clear
            .preference(key: SimilarProductsPositionKey.self, value: geo.frame(in: .global).minY)
    }
)
.onPreferenceChange(SimilarProductsPositionKey.self) { position in
    similarProductsPosition = position
}
ScrollView(.horizontal, showsIndicators: false) {
    HStack {
        ForEach(product.similar_products ?? [], id: \.id) { item in
            SimilarProductView(item: item)
        }
    }.padding(.horizontal)
}
.padding(.bottom, height/6)
*/

// 4. Update your scroll tracking logic in the GeometryReader:
/*
.onChange(of: geometry.frame(in: .global).minY) { geo in
    // Check if similar products section is visible on screen
    let screenHeight = UIScreen.main.bounds.height
    
    // The section is visible if its position is within the visible screen bounds
    let isSimilarProductsVisible = similarProductsPosition > 0 && 
                                   similarProductsPosition < screenHeight + 100 // Add some threshold
    
    if isSimilarProductsVisible {
        isScrolledDown = false
    } else if geo < -50 {
        isScrolledDown = true
    } else {
        isScrolledDown = false
    }
}
*/



