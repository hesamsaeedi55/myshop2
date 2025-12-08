import SwiftUI

// MARK: - Main GlassView (Optimized)
struct GlassView: View {
    
    @EnvironmentObject var categoryVM : CategoryViewModel
    @EnvironmentObject var attributeVM : AttributeViewModel
    @EnvironmentObject var sortVM : SortViewModel
    @EnvironmentObject var productVM : ProductViewModel
    @EnvironmentObject var navigationVM: NavigationStackManager


    @State var isCategoryMenViewActive : Bool = false
    @State var isCategoryWomenViewActive : Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    @State var floatingEffect : CGFloat = 10
    @State var nameImage : [String] = ["o1","o2","o3","o4","o5","blan"]
    @State var nameofthebackground : String = "blan"
    @State var onDragOption : Bool = false
    @EnvironmentObject var curNav : currentNavClass
    @State var move = false
    @State private var isDataLoaded = false
    @State private var showShimmer = true
    @State private var isManTapped: Bool = false
    @State private var isCategoryTapped: Bool = false
    @State var productFinal : ProductTest?
    @State var isFinalViewActive : Bool = false
    @State var textOpacity: Double = 0
    @State var textBlur: Double = 2
    @State var selectIndex: Int = 0
    @State var hitInvert : Bool = false
    @State var anyTapGesture : Bool = false
    @State var firstTimeInterval : Double = 2.0
    
    let imagesOfTest = ["f7","f5","f3","f2","f4","f1"]
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        
        ZStack {
//            GrainyNoiseBackground()
            VideoBackgroundView(videoName: "sss", playbackRate:1.2)
                .ignoresSafeArea(edges: .all)
                .opacity(hitInvert ? 0 : 1)
            
                VStack(spacing: 0) {
               
                    
                    GeometryReader { geo in
                            
                            
                            
                            // Fixed content layer with consistent spacing
                            VStack(spacing: 0) {
                                
                                // Fixed top spacing to prevent jumpin
                                
                                ScrollView(.vertical, showsIndicators: false) {
                                    VStack(spacing: 0) { // Fixed spacing instead of dynamic
                                        VStack {
                                            navigationBar()
                                            Spacer()
                                        }.opacity(0)
                                        
                                        Text("جدیدترین محصولات")
                                            .font(.custom("DoranNoEn-ExtraBold", size: 24))
                                            .foregroundStyle(.black)
                                            .frame(maxWidth:.infinity,alignment: .trailing)
                                            .padding(.trailing, 12) // Fixed padding
                                            .opacity(textOpacity)
                                            .blur(radius: textBlur)
                                            .onAppear {
                                                withAnimation(.easeIn(duration: 1.0)) {
                                                    textOpacity = 1
                                                    textBlur = 0
                                                }
                                            }
                                        
                                          
//                                        chartaee()

                                        // Categories ScrollView (empty for now)
                                            ImageArray() 
                                            .simultaneousGesture(
                                                   DragGesture(minimumDistance: 10) // even tiny drag
                                                       .onChanged { _ in
                                                           anyTapGesture = true
                                                       }
                                               )
                                                .onTapGesture {
                                                    anyTapGesture = true
                                                }
                                             
                                        
                                        Text("\(anyTapGesture)")
                                              
                                        // Add this line! width
//                                                    VStack {
//                                                        Spacer()
//                                                        Button {
//
//                                                            isCategoryMenViewActive = true
//
//                                                        }label:{
//                                                            Text("محصولات مردانه")
//                                                                .frame(width:geo.size.width/3)
//                                                                .foregroundStyle(.white)
//                                                                .font(.custom("DoranNoEn-Bold", size: 14))
//                                                                .padding(8)
//                                                                .shadow(color: .white, radius: 3)
//
//                                                        }
//                                                        .padding(2)
//                                                        Button {
//
//                                                            isCategoryWomenViewActive = true
//
//
//                                                        }label:{
//                                                            Text("محصولات زنانه")
//                                                                .frame(width:geo.size.width/3)
//                                                                .foregroundStyle(.white)
//                                                                .font(.custom("DoranNoEn-Bold", size: 14))
//                                                                .padding(8)
//                                                                .shadow(color: .white, radius: 3)
//
//                                                        }
//                                                        .padding(.bottom,100)
//                                                    }
//                                                }
                                            
                                        HStack {
                                            Spacer()
                                            
                                            Text("پیشنهاد های ما")
                                                .font(.custom("DoranNoEn-ExtraBold", size: 20))
                                                .foregroundStyle(.black)
                                                .padding(.trailing, 20) // Fixed padding
                                                .padding(.top, 10) // Fixed padding
                                              

                                        }
                                                // Products Section - Fixed height to prevent jumping
                VStack(spacing:0) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        LazyHStack(spacing: 12) { // Fixed spacing
                            if isDataLoaded && !productVM.newArrivals.isEmpty {
                                // Real products with staggered fade-in
                                ForEach(Array(productVM.newArrivals.prefix(8).enumerated()), id: \.element.id) { index, product in
                                    
                                    Button {
                                        Task { await productVM.loadFinalProduct(product.id)}
                                        productFinal = product
                                        isFinalViewActive = true
                                    }label: {
                                        CustomGlassMorphicCardSmooth(
                                            width: geo.size.width * 0.45, // Fixed calculation
                                            height: geo.size.height * 0.35, // Fixed calculation
                                            product: product,
                                            imageHeight: geo.size.width * 0.3
                                        )
                                        .padding(.horizontal, 8) // Fixed padding
                                        .opacity(isDataLoaded ? 1 : 0)
                                        .scaleEffect(isDataLoaded ? 1 : 0.95)
                                        .animation(.easeOut(duration: 0.5).delay(Double(index) * 0.08), value: isDataLoaded)
                                    }
                                }
                            } else {
                                // Shimmer placeholders - same exact dimensions
                                ForEach(0..<3, id: \.self) { index in
                                    ShimmerCard(
                                        width: geo.size.width * 0.45,
                                        height: geo.size.height * 0.35
                                    )
                                    .padding(.horizontal, 8)
                                    .opacity(showShimmer ? 1 : 0)
                                }
                            }
                        }
                        .padding(.horizontal, 12) // Fixed outer padding
                        .navigationDestination(isPresented: $isFinalViewActive ) {
                            if productFinal != nil {
                                finalView(productId: productFinal!.id,lastNavigation: .book)
                            }else{
                                
                            }
                        }
                    }
                }
                .frame(height: geo.size.height * 0.40)
                .onAppear {
                    // Start background animation immediately
                    withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                        move.toggle()
                    }
                    
                    // Load data with delay for smoother transition
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        Task {
                            do {
                                try await productVM.loadNewestItems()
                                // Remove animation from state change to prevent jumping
                                isDataLoaded = true
                                showShimmer = false
                            }catch{
                                
                            }
                        }
                    }
                }
                
                                        HStack {
                                            Spacer()
                                            
                                            Text("پیشنهاد های ما")
                                                .font(.custom("DoranNoEn-ExtraBold", size: 20))
                                                .foregroundStyle(.black)
                                                .padding(.trailing, 20) // Fixed padding
                                                .padding(.top, 10) // Fixed padding
                                              

                                        }
                                                // Products Section - Fixed height to prevent jumping
                VStack(spacing:0) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        LazyHStack(spacing: 12) { // Fixed spacing
                            if isDataLoaded && !productVM.newArrivals.isEmpty {
                                // Real products with staggered fade-in
                                ForEach(Array(productVM.newArrivals.prefix(8).enumerated()), id: \.element.id) { index, product in
                                    
                                    Button {
                                        Task { await productVM.loadFinalProduct(product.id)}
                                        productFinal = product
                                        isFinalViewActive = true
                                    }label: {
                                        CustomGlassMorphicCardSmooth(
                                            width: geo.size.width * 0.45, // Fixed calculation
                                            height: geo.size.height * 0.35, // Fixed calculation
                                            product: product,
                                            imageHeight: geo.size.width * 0.3
                                        )
                                        .padding(.horizontal, 8) // Fixed padding
                                        .opacity(isDataLoaded ? 1 : 0)
                                        .scaleEffect(isDataLoaded ? 1 : 0.95)
                                        .animation(.easeOut(duration: 0.5).delay(Double(index) * 0.08), value: isDataLoaded)
                                    }
                                }
                            } else {
                                // Shimmer placeholders - same exact dimensions
                                ForEach(0..<3, id: \.self) { index in
                                    ShimmerCard(
                                        width: geo.size.width * 0.45,
                                        height: geo.size.height * 0.35
                                    )
                                    .padding(.horizontal, 8)
                                    .opacity(showShimmer ? 1 : 0)
                                }
                            }
                        }
                        .padding(.horizontal, 12) // Fixed outer padding
                        .navigationDestination(isPresented: $isFinalViewActive ) {
                            if productFinal != nil {
                                finalView(productId: productFinal!.id,lastNavigation: .book)
                            }else{
                                
                            }
                        }
                    }
                }
                .frame(height: geo.size.height * 0.40)
                .onAppear {
                    // Start background animation immediately
                    withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                        move.toggle()
                    }
                    
                    // Load data with delay for smoother transition
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        Task {
                            do {
                                try await productVM.loadNewestItems()
                                // Remove animation from state change to prevent jumping
                                isDataLoaded = true
                                showShimmer = false
                            }catch{
                                
                            }
                        }
                    }
                }
                
          
                                        
                                        HStack {
                                            Spacer()
                                            
                                            Text("پیشنهاد های ما")
                                                .font(.custom("DoranNoEn-ExtraBold", size: 20))
                                                .foregroundStyle(.black)
                                                .padding(.trailing, 20) // Fixed padding
                                                .padding(.top, 10) // Fixed padding
                                              

                                        }
                                                // Products Section - Fixed height to prevent jumping
                VStack(spacing:0) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        LazyHStack(spacing: 12) { // Fixed spacing
                            if isDataLoaded && !productVM.newArrivals.isEmpty {
                                // Real products with staggered fade-in
                                ForEach(Array(productVM.newArrivals.prefix(8).enumerated()), id: \.element.id) { index, product in
                                     
                                    Button {
                                        Task { await productVM.loadFinalProduct(product.id)}
                                        productFinal = product
                                        isFinalViewActive = true
                                    }label: {
                                        CustomGlassMorphicCardSmooth(
                                            width: geo.size.width * 0.45, // Fixed calculation
                                            height: geo.size.height * 0.35, // Fixed calculation
                                            product: product,
                                            imageHeight: geo.size.width * 0.3
                                        )
                                        .padding(.horizontal, 8) // Fixed padding
                                        .opacity(isDataLoaded ? 1 : 0)
                                        .scaleEffect(isDataLoaded ? 1 : 0.95)
                                        .animation(.easeOut(duration: 0.5).delay(Double(index) * 0.08), value: isDataLoaded)
                                    }
                                }
                            } else {
                                // Shimmer placeholders - same exact dimensions
                                ForEach(0..<3, id: \.self) { index in
                                    ShimmerCard(
                                        width: geo.size.width * 0.45,
                                        height: geo.size.height * 0.35
                                    )
                                    .padding(.horizontal, 8)
                                    .opacity(showShimmer ? 1 : 0)
                                }
                            }
                        }
                        .padding(.horizontal, 12) // Fixed outer padding
                        .navigationDestination(isPresented: $isFinalViewActive ) {
                            if productFinal != nil {
                                finalView(productId: productFinal!.id,lastNavigation: .book)
                            }else{
                                
                            }
                        }
                    }
                }
                .frame(height: geo.size.height * 0.40)
                .onAppear {
                    // Start background animation immediately
                    withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                        move.toggle()
                    }
                    
                    // Load data with delay for smoother transition
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        Task {
                            do {
                                try await productVM.loadNewestItems()
                                // Remove animation from state change to prevent jumping
                                isDataLoaded = true
                                showShimmer = false
                            }catch{
                                
                            }
                        }
                    }
                }
                
          
                                        
                                        HStack {
                                            Spacer()
                                            
                                            Text("پیشنهاد های ما")
                                                .font(.custom("DoranNoEn-ExtraBold", size: 20))
                                                .foregroundStyle(.black)
                                                .padding(.trailing, 20) // Fixed padding
                                                .padding(.top, 10) // Fixed padding
                                              

                                        }
                                                // Products Section - Fixed height to prevent jumping
                VStack(spacing:0) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        LazyHStack(spacing: 12) { // Fixed spacing
                            if isDataLoaded && !productVM.newArrivals.isEmpty {
                                // Real products with staggered fade-in
                                ForEach(Array(productVM.newArrivals.prefix(8).enumerated()), id: \.element.id) { index, product in
                                    
                                    Button {
                                        Task { await productVM.loadFinalProduct(product.id)}
                                        productFinal = product
                                        isFinalViewActive = true
                                    }label: {
                                        CustomGlassMorphicCardSmooth(
                                            width: geo.size.width * 0.45, // Fixed calculation
                                            height: geo.size.height * 0.35, // Fixed calculation
                                            product: product,
                                            imageHeight: geo.size.width * 0.3
                                        )
                                        .padding(.horizontal, 8) // Fixed padding
                                        .opacity(isDataLoaded ? 1 : 0)
                                        .scaleEffect(isDataLoaded ? 1 : 0.95)
                                        .animation(.easeOut(duration: 0.5).delay(Double(index) * 0.08), value: isDataLoaded)
                                    }
                                }
                            } else {
                                // Shimmer placeholders - same exact dimensions
                                ForEach(0..<3, id: \.self) { index in
                                    ShimmerCard(
                                        width: geo.size.width * 0.45,
                                        height: geo.size.height * 0.35
                                    )
                                    .padding(.horizontal, 8)
                                    .opacity(showShimmer ? 1 : 0)
                                }
                            }
                        }
                        .padding(.horizontal, 12) // Fixed outer padding
                        .navigationDestination(isPresented: $isFinalViewActive ) {
                            if productFinal != nil {
                                finalView(productId: productFinal!.id,lastNavigation: .book)
                            }else{
                                
                            }
                        }
                    }
                }
                .frame(height: geo.size.height * 0.40)
                .onAppear {
                    // Start background animation immediately
                    withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                        move.toggle()
                    }
                    
                    // Load data with delay for smoother transition
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        Task {
                            do {
                                try await productVM.loadNewestItems()
                                // Remove animation from state change to prevent jumping
                                isDataLoaded = true
                                showShimmer = false
                            }catch{
                                
                            }
                        }
                    }
                }
                
          

        Image("north")
            .resizable()
            .scaledToFit()
            .colorInvert()
            .blendMode(.darken)
        
        HStack {
            Spacer()
            
            Text("پیشنهاد های ما")
                .font(.custom("DoranNoEn-ExtraBold", size: 20))
                .foregroundStyle(.black)
                .padding(.trailing, 20) // Fixed padding
                .padding(.top, 10) // Fixed padding
              

        }
      
        
        // Build Section Header
        HStack {
            Spacer()
            
            Text("وایبت رو بساز")
                .font(.custom("DoranNoEn-ExtraBold", size: 24))
                .foregroundStyle(.black)
                .padding(.trailing, 20)
        }
        
        // Home Sections - Fixed dimensions
        Group {
            if isDataLoaded {
                HomeSections()
                    .shadow(radius: 6, y: 4)
                    .frame(width: geo.size.width * 0.95, height: geo.size.width * 0.95)
                    .opacity(isDataLoaded ? 1 : 0)
                    .animation(.easeOut(duration: 0.4).delay(0.3), value: isDataLoaded)
            } else {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.white.opacity(0.1))
                    .frame(width: geo.size.width * 0.95, height: geo.size.width * 0.95)
            }
        }
        .padding(.vertical, 16)
        
        // Latest Items Header
        HStack {
            Spacer()
            
            Text("جدیدترین‌ها")
                .font(.custom("DoranNoEn-ExtraBold", size: 20))
                .foregroundStyle(.black)
                .padding(.trailing, 20)
        }
        
                                        // Bottom spacing
                                        Spacer()
                                            .frame(height: 100) // Fixed bottom space for tab bar
                                    }
                            }
                            .navigationBarHidden(true)
                        
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            VStack {
                navigationBar()
                Spacer()
            }
        }.ignoresSafeArea()
        
    }
    
//    @ViewBuilder
//    func chartaee() -> some View {
//        
//        LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 300, maximum: 350)), count: 2), spacing: 10) {
//            ForEach(0..<100, id: \.self) { index in
//                Image("f1")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//            }
//        }
//        
//    }
    
    @ViewBuilder
    func ImageArray() -> some View {
        TabView(selection:$selectIndex) {
            ForEach(imagesOfTest.indices, id: \.self) {
                index in VStack {
                    Image(imagesOfTest[index])
                        .resizable()
                        .brightness(
                            anyTapGesture
                            ?
                            (index == selectIndex ? 0 : -0.20)
                                : 0
                                )
                        .animation(anyTapGesture ?
                        
                            .spring(response: 1,dampingFraction: 0.8)
                                   
                                   : nil,value: selectIndex
                                    )
                    VStack {
                        HStack {
                            Spacer()
                            Text("ست پاییزی قهوه‌ای به همراه بوت و کیف چرم") .font(.custom("AbarHighNoEn-SemiBold", size: width/36, relativeTo: .body))
//                                .opacity(index == selectIndex ? 1 : 0)
                                .multilineTextAlignment(.trailing)
                                .padding(.bottom) .frame(width:width/5)
//                                .offset(y: index == selectIndex ? 0 : 25)
                        }
                    }
                }
            }
        }

        .aspectRatio(1.5/3, contentMode: .fill)
        .clipShape(Rectangle())
         
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            // First timer: fires once after 2 seconds
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                withAnimation(.spring()) {
                    if !anyTapGesture {
                        selectIndex = (selectIndex + 1) % imagesOfTest.count
                    }
                }

                // Now start the repeating timer every 4 seconds
                Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
                    withAnimation(.spring()) {
                        if !anyTapGesture {
                            selectIndex = (selectIndex + 1) % imagesOfTest.count
                        }
                    }
                }
            }
        }
       
        .frame(width:width/1.6)
       
    }
    
    @ViewBuilder
    func navigationBar() -> some View {
        
        VStack {
            Spacer()
            
            HStack(alignment:.bottom) {
                
                HStack {
                    Button(action: {
                        
                        navigationVM.popView(from:.profile)
                        
                    }) {
                        Image(systemName: "chevron.left.circle.fill")
                            .resizable()
                            .frame(width: width/16, height: width/16)
                            .foregroundStyle(.black)
                    }
                    Spacer()
                }
                .frame(width: width/4.4, height: width/18)
                .padding(.leading,width/18)
                .padding(.bottom,10)
                
                
                Spacer()
                
                
                Text("صفحه اصلی")
                    .font(.custom("DoranNoEn-Bold", size: 20))
                
                Spacer()
                
                Button {
                  
                    
                    
                }label:{
                    Text("")
                        .font(.custom("DoranNoEn-Bold", size: 16))
                        .frame(width: width/4.4, height: width/18)
                }
                .padding(.trailing,width/18)
                .navigationBarBackButtonHidden(true)
                .ignoresSafeArea()
                
            }
            .padding(.bottom,2)
            
        }
        .frame(height: height/9 )
        .background(CustomBlurView(effect: .systemThinMaterial))
        
    }
}





// MARK: - Smooth Shimmer Loading Card
struct ShimmerCard: View {
    
    
    let width: CGFloat
    let height: CGFloat
    @State private var phase: CGFloat = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(radius: 4)
        }
        .overlay {
            VStack {
                // Fixed shimmer implementation for image placeholder 
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.05))
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.clear,
                                    Color.white.opacity(0.15),
                                    Color.clear 
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .offset(x: phase * width - width)
                        .clipped()
                        .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: phase)
                }
                .frame(width: width * 0.85, height: height * 0.65)
                .padding(.vertical, 8)
                
                // Text placeholder with shimmer
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.05))
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.clear,
                                    Color.white.opacity(0.1),
                                    Color.clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .offset(x: phase * width * 0.7 - width * 0.7)
                        .clipped()

                }
                .frame(width: width * 0.7, height: 20)
                
                Spacer()
            }
        }
        .frame(width: width, height: height)
        .onAppear {
            // Start shimmer animation
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                phase = 1
            }
        }
    }
}

// MARK: - Optimized CustomGlassMorphicCard
struct CustomGlassMorphicCardSmooth: View {
    let width: CGFloat
    let height: CGFloat
    let product: ProductTest
    let imageHeight: CGFloat
    @State private var imageLoaded = false
    
    var body: some View {
        ZStack {
            // Simplified blur layer for better performance
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(radius: 4)
        }
        .overlay {
            VStack {
                // Optimized image loading with AsyncImage
                AsyncImage(url: URL(string: product.images.first(where: { $0.isPrimary })?.url ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .transition(.opacity.animation(.easeOut(duration: 0.3)))
                            .onAppear { imageLoaded = true }
                    case .failure(_):
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    case .empty:
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.1))
                            .overlay(
                                ProgressView()
                                    .scaleEffect(0.8)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: width * 0.85, height: height * 0.65)
                .cornerRadius(20)
                .padding(.vertical, 8)
                
                Text(product.name)
                    .modifier(CustomModifierOptimized(font: .custom("DoranNoEn-Light", size: 16)))
                    .frame(width: width * 0.85)
                    .opacity(imageLoaded ? 1 : 0.5)
                    .animation(.easeOut(duration: 0.3).delay(0.1), value: imageLoaded)

                Spacer()
            }
        }
        .frame(width: width, height: height)
    }
}

// MARK: - Original CustomGlassMorphicCard for compatibility
struct CustomGlassMorphicCard: View {
    let width: CGFloat
    let height: CGFloat
    let product: ProductTest
    let imageHeight: CGFloat
    
    var body: some View {
        ZStack {
            // Base blur layer
            CustomBlurView(effect: .systemUltraThinMaterialDark)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(radius: 8)
        }
        .overlay {
            VStack {
                AsyncImage(url: URL(string: product.images.first(where: { $0.isPrimary })?.url ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: width * 0.85, height: height * 0.65)
                .cornerRadius(20)
                .padding(.vertical,8)
                 
                Text("\(product.name)")
                    .modifier(CustomModifier(font:(.custom("DoranNoEn-Light", size: 16))))
                    .blendMode(.overlay)
                    .frame(width: width * 0.85)

                Spacer()
            }
        }
        .frame(width: width, height: height)
    }
}

// MARK: - Optimized Custom Modifier
struct CustomModifierOptimized: ViewModifier {
    var font: Font
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .fontWeight(.medium)
            .foregroundStyle(.black)
            .shadow(radius: 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
    }
}

// MARK: - Original Custom Modifier for compatibility
struct CustomModifier: ViewModifier {
    var font: Font
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .font(font)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .kerning(1.2)
                .shadow(radius: 15)
                .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            content
                .font(font)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Custom Blur View
struct CustomBlurView: UIViewRepresentable {
    var effect: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: effect))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: effect)
    }
}

// MARK: - Supporting Classes
class currentNavClass : ObservableObject {
    @Published var currentNav : NavBarImage = .wishlist
}

enum NavBarImage {
    case home, address, wishlist, profile, purchase

    var imageName: String {
        switch self {
        case .home, .address, .wishlist, .profile, .purchase:
            return "o4"
        }
    }

    var title: String {
        switch self {
        case .home, .address, .wishlist, .profile, .purchase:
            return "شاپترست"
        }
    }
}


#Preview {
    GlassView()
        .environmentObject(ProductViewModel())
        .environmentObject(AttributeViewModel())
        .environmentObject(SortViewModel())
        .environmentObject(CategoryViewModel())
        .environmentObject(NavigationStackManager())

}
