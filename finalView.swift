
//
//  PlacesView.swift
//  ssssss
//
//  Created by Hesamoddin Saeedi on 6/18/23.
//


import SwiftUI
import Combine
import Kingfisher

 

struct finalView: View {
    
    // MARK: - Constants
    
    
    
    let height = UIScreen.main.bounds.size.height
    let width = UIScreen.main.bounds.size.width
    let images: [String] = ["o4", "o2", "o1", "o3", "o4"]
    let sizes: [String: Bool] = ["XS": false, "S": false, "M": true, "L": true, "XL": false]
    let sizeOrder = ["XS", "S", "M", "L", "XL"]
    
    var attributeImages : [String] = []
    
    // MARK: - Environment & Observed Objects
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var attVM: AttributeViewModel
    @EnvironmentObject var viewModel: ProductViewModel
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var catVM: CategoryViewModel
    @EnvironmentObject var basketVM: shoppingBasketViewModel
    @State private var wishlistState: wishlistResult = .idle

    
    // MARK: - UI States
    @State var variantArray: [String] = []
    @State var imagesOfDisplay: [String] = []
    @State var isPresented = false
    @State var selectedImage: String = ""
    @State var blurAnimation: CGFloat = 0
    @State var saveButton = false
    @State private var isDeleteTapped = false
    @State var isFullScreen: Bool = false
    @State var isTapped: Bool = false
    @State private var isButtonDisabled = false
    @State var shimmerView = false
    @State var specialAttribute: String = ""
    @State var selectedColor = ""
    @State var selectedVariantId: Int = 0
    @State var isShowingPopup: Bool = false
    @State var attributeName: String = ""
    @State var distinctiveName: String = ""
    // MARK: - Image States
    @State private var cachedImages: [UIImage] = []
    @State private var isLoading = true
    @State private var currentIndex = 0
    @State private var onceDone: Bool = true
    @State private var multipleVariantAttribute: Int = 0
    // MARK: - Gesture & Animation States
    @State private var isLiked: Bool = false
    @State private var scale1: CGFloat = 1.0
    @State private var previousOffset: CGFloat = 0
    @State private var dragProgress: CGFloat = 0
    @State private var lastSwipeDirection: SwipeDirection = .none
    @State private var temp: CGFloat = 0
    @State private var screenWidth: CGFloat = UIScreen.main.bounds.width
    @State private var newofffset: CGFloat = 0
    @State private var geoWatch: CGFloat = 0
    @State private var fullScreen: Bool = false
    @State private var scale: CGFloat = 1.0
    @State private var blurAmount: CGFloat = 0
    @State private var dragOffsetPopup: CGFloat = 0
    @State private var selectedUI: CategoryUI?
    @State private var isScrolledDown: Bool = false
    @State private var hasSetInitialGeo = true
    @State var initialGeo: CGFloat = 0
    @State private var similarProductsPosition: CGFloat = 0
    @EnvironmentObject var navigationManager: NavigationStackManager
    @State private var isInWishlist: Bool = false

    let productId: Int?
    
    init(productId: Int,lastNavigation: NavigationStackManager.TabPage?) {
        self.productId = productId
        self.lastNavigation = lastNavigation
    }
    
    let lastNavigation: NavigationStackManager.TabPage?
    
    // MARK: - Enums
    enum SwipeDirection {
        case none, left, right
    }
    
    enum CategoryUI {
        case watches, clothes
    }
  
    
    
    var body: some View {
        
        ZStack {
            
            removeFromWishList()
            
            
            Group {
                if let product = viewModel.product {
                    VStack(spacing:0) {
                                                
                        
                        ScrollViewReader { proxy in
                            ScrollView(showsIndicators:false) {
                                
                                
                                GeometryReader { geometry in
                                    
                                    
                                    imageTab(geometry: geometry, proxy: proxy)
                                    
                                    VStack {
                                        
                                        Spacer()
                                          
                                        //
                                        //                                .background(CustomBlurView(effect: .systemUltraThinMaterialDark)
                                        //                                    .frame(width: width*2, height: height/6)
                                        //                                    .blur(radius: 20)
                                        //                                    .offset(y:10)
                                        //                                )
                                        
                                    }.clipped()
                                    
                                    
                                        .onChange(of: currentIndex) { value in
                                            if value != 1 {
                                                temp = 0
                                                onceDone = false
                                            }
                                        }
                                    
                                        .onAppear {
                                                Task {
                                                   let checkWishlistItem = try await viewModel.checkWishlistItem(product)
                                                    if checkWishlistItem {
                                                        isLiked = true
                                                    }else{
                                                        
                                                    }
                                                }
                                        }
                                    
                                        .onChange(of:geometry.frame(in: .global).minY) { geo in
                                            let screenHeight = UIScreen.main.bounds.height
                                            
                                            // Only check if similar products section position has been set (not 0)
                                            // The section is visible if its top edge is within the visible screen area
                                            let isSimilarProductsVisible = similarProductsPosition > 0 &&
                                                                           similarProductsPosition < screenHeight
                                            
                                            if isSimilarProductsVisible {
                                                // Hide button when similar products section is visible
                                                isScrolledDown = false
                                            } else if geo < -50 {
                                                // Show button when scrolled down past the image
                                                isScrolledDown = true
                                            } else {
                                                // Hide button when at the top
                                                isScrolledDown = false
                                            }
                                        }
                                    
                                }
                                .aspectRatio(3.0/4.0, contentMode: .fit)
                                
                                .onAppear {
                                    print(product.display_attributes ?? [])
                                }
                                
                                VStack(spacing:0) {
                                    
                                    imageTabIndicator()
                                    
                                    HStack {
                                        Spacer()
                                        
                                        Text(product.name)
                                        //                                        .font(.custom("DoranNoEN-Bold", size: 32))
                                            .font(.custom("AbarHighNoEn-SemiBold", size: width/26, relativeTo: .body))
                                            .multilineTextAlignment(.trailing)
                                            .padding(.trailing,width/50)
                                        
                                    }
                                    price()
                                    
                                    VariantSelectorView(product: product, width: width, widthColor: width/26, widthSize: width/26)
                                    
                                    Divider()
                                        .padding()
                                    attribute_Display()
                                    Divider()
                                        .padding(.top)
                                        .onAppear {
                                            if let product = viewModel.product,
                                                let variants = product.variants, !variants.isEmpty {
                                                let _ = variants.compactMap({ variant in
                                                    
                                                    if variant.attributes.count > 1 {
                                                        multipleVariantAttribute = 2
                                                        return variant
                                                    }else if variant.attributes.count == 1{
                                                        multipleVariantAttribute = 1
                                                        return variant
                                                    }else{
                                                        multipleVariantAttribute = 0
                                                        return variant
                                                        
                                                    }
                                                })
                                            }
                                        }
                                    
                                }

                                
                                DropDownMenu(text: product.description ?? "", width: width,font: .custom("AbarHighNoEn-SemiBold", size: 16, relativeTo: .body), fontCaption: .custom("AbarHighNoEn-SemiBold", size: 14, relativeTo: .body))
                                 
                                Divider()
                                    .padding(.top)
                                  
                                
                                attributeSection()
                                
                                
                                
                                
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
                                    similarProductsPosition = position + height/5
                                }
                                
                                ScrollView(.horizontal,showsIndicators: false) {
                                    
                                    HStack {
                                        ForEach(product.similar_products ?? [],id:\.id) { item in
                                            SimilarProductView(item: item)
                                        }
                                    }.padding(.horizontal)
                                }
                                .padding(.bottom,height/6)

                            }
                            
                            .navigationViewStyle(StackNavigationViewStyle())
                        }
                    }
                } else {
                    // Loading state
                    VStack {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("در حال بارگذاری...")
                            .font(.custom("AbarHighNoEn-SemiBold", size: 16))
                            .padding(.top, 20)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                 
                }
            }
            
            VStack {
                HStack {
                    Button(action: {
                        Task {
                            if let product = viewModel.product {
                                viewModel.product = nil
                                ImageStore.shared.clear(prefix: "product-\(product.id)")
                            }
                        }
                        
                        
                        navigationManager.popView(from: lastNavigation)
                        
                        
                    }) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: width/38, height: width/22)
                            .foregroundStyle(.black)
                            .padding()
                    }
                    Spacer()
                }
                Spacer()
            }
            
            
            addToWishlist()
            
            
            
           
            wishlistFeedbackView()
            
            
            
            
            if isFullScreen, let product = viewModel.product {
                ZStack {
                    ImageSliderView(product: product, currentIndex: currentIndex, selectedColor: selectedColor, imagesOfDisplay: imagesOfDisplay, onClose: {isFullScreen = false})
                    
                }
            }
            // MARK: - size pop up
            ZStack {
                GeometryReader { geo in
                    VStack {
                        Rectangle()
                            .fill(Color.clear)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                isShowingPopup = false
                            }
                        
                        Spacer()
                        popup(isShowingPopup, height: height)
                    }
                }
            }
            .offset(y: dragOffsetPopup)
            .opacity(isShowingPopup ? 1 : 0)
            .ignoresSafeArea()
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height > 0 {
                            dragOffsetPopup = value.translation.height
                        }
                    }
                    .onEnded { value in
                        // More sensitive thresholds - use .height instead of .y
                        if value.translation.height > 30 || value.predictedEndTranslation.height > 50 {
                            
                            withAnimation(.easeOut(duration: 0.25)) {
                                isShowingPopup = false
                                dragOffsetPopup = 0
                            }
                            
                        }else{
                            withAnimation(.easeOut(duration: 0.25)) {
                                
                                dragOffsetPopup = 0
                            }
                        }
                    }
            )
            
            
        }
        // Load product & images once per productId
        .task(id: productId) {
            guard let productId = productId else { return }
            
            // Only load if we don't already have this product
            if viewModel.product == nil || viewModel.product?.id != productId {
                await viewModel.loadFinalProduct(productId)
            }
            
            guard let product = viewModel.product, product.id == productId else {
                print("⚠️ Product failed to load or mismatched id (expected \(productId))")
                return
            }
            
            // Then load images based on variants
            if product.variants != [] {
                await loadImagesFromURLs()
            } else {
                let urls = product.images.compactMap { URL(string: $0.url ?? "") }
                cachedImages = await ImageStore.shared.preload(
                    urls: urls,
                    keyPrefix: "product-\(product.id)"
                )
                isLoading = false
            }
        }
        .navigationBarHidden(true)
        
    }
    
    @ViewBuilder
        private func wishlistFeedbackView() -> some View {
            ZStack {
                CustomBlurView(effect: .systemThinMaterial)
                    .ignoresSafeArea()
                
                VStack(spacing: 12) {
                    switch wishlistState {
                    case .idle:
                        EmptyView()
                        
                    case .adding:
                        Text("Adding...")
                            .font(.custom("DoranNoEn-Bold", size: 16, relativeTo: .body))
                            .foregroundColor(.black)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        
                    case .success(let message):
                        Text(message)
                            .font(.custom("DoranNoEn-Bold", size: 16, relativeTo: .body))
                            .foregroundColor(.black)
                            .padding()
                            .background(CustomBlurView(effect: .systemUltraThinMaterial))
                            .cornerRadius(10)
                        
                    case .failure(let message):
                        Text(message)
                            .font(.custom("DoranNoEn-Bold", size: 16, relativeTo: .body))
                            .foregroundColor(.red)
                            .padding()
                            .background(CustomBlurView(effect: .systemUltraThinMaterial))
                            .cornerRadius(10)
                    }
                }
            }
            .opacity(wishlistState == .idle ? 0 : 1)
            .zIndex(15)
            .animation(.easeInOut(duration: 0.3), value: wishlistState)
        }
    
    
    struct ImageSliderView: View {
        let product: ProductTest
        @State  var currentIndex : Int
        @State  var dragProgress: CGFloat = 0
        @State  var newOfffset: CGFloat = 0
        @State  var lastSwipeDirection: SwipeDirection = .none
        @State  var onceDone: Bool = true
        @State  var selectedColor : String
        @State  var temp : CGFloat = 0
        @State  var imagesOfDisplay : [String]
        @State  var cachedImages: [UIImage] = []
        let onClose: () -> Void
        
        enum SwipeDirection {
            case none, left, right
        }
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        var body: some View {
            ZStack {
                //MARK: - TAB
                
                TabView(selection: $currentIndex) {
                    ForEach(cachedImages.indices, id: \.self) { idx in
                        GeometryReader { geometry in
                            Image(uiImage: cachedImages[idx])
                                .resizable()
                            
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width,
                                       
                                       height:
                                        
                                        geometry.size.height )
                            
                                .id("hero-\(idx)")
                            
                                .background(
                                    GeometryReader { geo in
                                        Color.clear
                                            .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .global).minX)
                                    }
                                )
                            
                                .clipped()
                        }
                        .ignoresSafeArea()
                        
                    }
                    
                }
                .ignoresSafeArea()
                
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onPreferenceChange(ScrollOffsetKey.self) { newOffset in
                    
                    updateDragProgress(newOffset)
                }
                .onAppear {
                    Task {
                        cachedImages.removeAll()
                        
                        
                        let urls = imagesOfDisplay.compactMap { URL(string: $0) }
                        
                        if !urls.isEmpty {
                            cachedImages = await ImageStore.shared.preload(urls: urls, keyPrefix: "variant-\(selectedColor)", forceRefresh: true)
                            print("Successfully loaded \(cachedImages.count) images")
                        } else {
                            print("No valid URLs found")
                        }                        }
                }
                
                //MARK: - INDICATOR
                
                HStack {
                    if product.variants != [] {
                        VStack(alignment:.leading,spacing: height/100) {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    
                                    // Use imagesOfDisplay instead of trying to access variant directly
                                    ForEach(Array(imagesOfDisplay.enumerated()), id: \.offset) { (idx, imageUrl) in
                                        Rectangle()
                                            .frame(width: getDynamicWidth(for: idx), height: 1.5)
                                            .onTapGesture {
                                                withAnimation {
                                                    currentIndex = idx
                                                }
                                            }
                                    }
                                    
                                    Spacer()
                                }
                                .frame(width:width/1, height: height / 50)
                            }
                        }
                    }else{
                        VStack(alignment:.leading,spacing: height/100) {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    ForEach(Array(product.images.enumerated()), id: \.element.id) { (idx, imageUrl) in
                                        Rectangle()
                                            .frame(width: getDynamicWidth(for: idx), height: 1.5)
                                            .onTapGesture {
                                                withAnimation {
                                                    currentIndex = idx
                                                }
                                            }
                                    }
                                    
                                    Spacer()
                                }
                                .frame(width:width/1, height: height / 50)
                            }
                        }
                    }
                }
                .frame(width:width)
                .task(id: product.id) {
                    let urls = product.images.compactMap { URL(string: $0.url ?? "") }
                    print(product.id)
                    cachedImages = await ImageStore.shared.preload(urls: urls, keyPrefix: "product-\(product.id)")
                    //                isLoading = false
                }
                
                .onChange(of: currentIndex) { value in
                    if value != 1 {
                        temp = 0
                        onceDone = false
                    }
                }
                
                //MARK: - ZSTACK
                
            }
            .overlay(
                Button {
                    onClose()
                } label: {
                    ZStack {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: width/9, height: width/9)
                            .foregroundStyle(.ultraThinMaterial)
                    }
                }
                    .padding(.leading,width/12)
                    .padding(.top,width/12)
                
                , alignment: .topLeading
            )
            
        }
        
        private func getDynamicWidth(for index: Int) -> CGFloat {
            let baseWidth = width / 30
            let expandedWidth = width / 6
            let nextIndex = currentIndex + 1
            let previousIndex = currentIndex - 1
            
            
            
            
            if lastSwipeDirection == .right {
                
                if index == currentIndex {
                    
                    if dragProgress == 1 {
                        return expandedWidth
                    } else if dragProgress >= 0.5 {
                        
                        return expandedWidth
                        
                    }else if dragProgress < 0.5 {
                        return expandedWidth - (expandedWidth * dragProgress)
                    }
                }
                
                if index == nextIndex {
                    
                    if dragProgress == 1 {
                        return baseWidth
                    } else if dragProgress >= 0.5 {
                        
                        return baseWidth
                        
                    }else if dragProgress < 0.5 {
                        let reduction = expandedWidth * dragProgress
                        return baseWidth + reduction
                    }
                    
                }
                else if index == previousIndex {
                    
                    if dragProgress == 1 {
                        
                        return baseWidth
                    } else if dragProgress >= 0.5 {
                        
                        return baseWidth
                        
                    }else if dragProgress < 0.5 {
                        return baseWidth
                        
                    }
                }
            }
            
            
            
            
            
            else if lastSwipeDirection == .left {
                
                if index == currentIndex {
                    
                    if temp < 0.5 && temp != 0{
                        
                        if dragProgress < 0.5 {
                            
                            return expandedWidth
                            
                        }else if dragProgress == 1 {
                            
                            
                            return expandedWidth
                            
                        }else{
                            
                            return expandedWidth - (expandedWidth * temp)
                            
                        }
                        
                    }
                    
                    if dragProgress == 1 {
                        return expandedWidth
                        
                    } else if dragProgress >= 0.5 {
                        
                        return expandedWidth
                        
                    }else if dragProgress < 0.5 {
                        return expandedWidth - (expandedWidth * dragProgress)
                    }
                    
                    if dragProgress < 0.5 {
                        return expandedWidth - (expandedWidth * dragProgress)
                    }
                }
                
                if index == nextIndex {
                    
                    if temp < 0.5 {
                        
                        if dragProgress < 0.5 {
                            
                            return baseWidth
                            
                        }else if dragProgress != 1{
                            let reduction = expandedWidth * temp
                            return baseWidth + reduction
                        }else{
                            return baseWidth
                        }
                    }
                    
                    if dragProgress == 1 {
                        
                        return baseWidth
                        
                    } else if dragProgress >= 0.5 {
                        
                        return baseWidth
                        
                        
                    }else if dragProgress < 0.5 {
                        
                        return baseWidth
                    }
                    
                }
                
                else if index == previousIndex {
                    
                    if temp < 0.5 && temp != 0{
                        
                        
                        if dragProgress < 0.5 {
                            
                            return baseWidth
                            
                        }else{
                            
                            return baseWidth
                        }
                    }
                    
                    if dragProgress == 1 {
                        
                        return baseWidth
                        
                    } else if dragProgress >= 0.5 {
                        
                        return baseWidth
                        
                    }else if dragProgress < 0.5 {
                        
                        let reduction = expandedWidth * dragProgress
                        return baseWidth + reduction
                        
                    }
                }
                
            }
            
            
            else if lastSwipeDirection == .none {
                if index == currentIndex {
                    return expandedWidth
                }
            }
            
            return baseWidth
            
            
        }
        
        private func updateDragProgress(_ newOffset: CGFloat) {
            
            let screenWidth = width
            
            let progress = newOffset.truncatingRemainder(dividingBy: screenWidth) / screenWidth
            
            
            
            if currentIndex == 1 && onceDone {
                temp = abs(-progress)
            }
            //
            dragProgress = abs(min(max(0,1-progress),1+progress))
            
            //        if currentIndex == 1 && onceDone {
            //
            //            lastSwipeDirection = .right
            //            dragProgress = abs(progress)
            //
            //        }else{
            //
            //            dragProgress = abs(1-progress)
            //
            //        }
            
            newOfffset = newOffset
            
            
            let isNowSwipingRight = newOffset > 0
            let isNowSwipingLeft = newOffset < 0
            let isNowStopepd = lastSwipeDirection == .none
            // Determine swipe direction
            
            
            if isNowSwipingRight {
                
                lastSwipeDirection = .right
                
            } else if isNowSwipingLeft {
                
                
                lastSwipeDirection = .left
                
            }
        }
    }
    
    
    
    
    
    struct SimilarProductView: View {
        let item: similarProducts
        @State private var image: UIImage?
        
        var body: some View {
            VStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                } else {
                    Image(systemName: "photo")
                        .frame(width: 100, height: 100)
                        .background(Color.gray.opacity(0.3))
                }
                
                Text(item.name ?? "")
                    .font(.caption)
            }
            .task {
                if let url = item.image_url {
                    image = await SimpleImageCache.shared.loadImage(from: url)
                }
            }
        }
    }
    
    // MARK: - DESCRIPTION VIEW
    
    struct DropDownMenu: View {
        
        
        
        @State var show = false
        @State var show2 = false
        
        let title = "درباره محصول"
        let text : String
        
        let width: CGFloat
        let font: Font
        let fontCaption: Font
        
        var body: some View {
            Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            show.toggle()
                        }
                    
            }label:{
                VStack(spacing: 0) {
                    
                    HStack {
                        Image(systemName: "chevron.right")
                            .rotationEffect(.degrees(show ? 90 : 180))
                        Spacer()
                        
                        Text(title)
                            .font(font)
                        
                        
                    }
                    .padding(.horizontal)
                    
                    
                    
                    VStack(spacing: 0) {
                        if show {
                            Text(text)
                            
                                .multilineTextAlignment(.trailing)
                                .font(.custom("AbarHighNoEn-SemiBold", size: 16, relativeTo: .body))
                            }
                        }  .animation(.easeInOut(duration: 0.3), value: show)
                    
                    }
                }
            .foregroundStyle(.black)
            }
        }
    
    
    
    //MARK: - POP UP VIEW
    @ViewBuilder
    func popup(_ isShowing: Bool,height:CGFloat) -> some View {
        VStack(alignment:.trailing) {
            
            if let product = viewModel.product, let variants = product.variants, !variants.isEmpty {
                
                if multipleVariantAttribute > 1 {
                    
                    let followerDistinctiveName = Set(variants.compactMap({ variant in
                        variant.attributes.first(where: {$0.isDistinctive != true})?.display_name
                    }))
                    
                    HStack {
                        Spacer()
                        Text("\(followerDistinctiveName.first ?? "") مورد نظر رو انتخاب کنید")
                            .font(.custom("DoranNoEn-Bold",size:16))
                            .foregroundStyle(.black)
                            .padding(.horizontal)
                            .padding(.vertical,10)
                        Spacer()
                    }
                    
                    let allSizes = Set(variants.flatMap{ variant in
                        
                        variant.attributes.filter {
                            $0.isDistinctive == false
                        }.map {$0.value}
                        
                    }).sorted(by:{ size1,size2 in
                        
                        let sizeOrder = ["XS","S","M","L","XL","XXL"]
                        
                        let index1 = sizeOrder.firstIndex(of: size1) ?? Int.max
                        let index2 = sizeOrder.firstIndex(of: size2) ?? Int.max
                        
                        return index1 < index2
                        
                    })
                    
                    let stockSizes = variants.compactMap ({ variant in
                        
                        let size = variant.attributes.first {
                            $0.isDistinctive == false
                        }.map {$0.value}
                        
                        let color = variant.attributes.first {
                            $0.isDistinctive == true
                        }.map {$0.value}
                        
                        if color == selectedColor && variant.stock_quantity == 0 {
                            return size
                        }else{
                            return nil
                        }
                        
                    })
                    
                    
                    let availableSizes = variants.compactMap ({ variant in
                        
                        let size = variant.attributes.first {
                            $0.isDistinctive == false
                        }.map {$0.value}
                        
                        let color = variant.attributes.first {
                            $0.isDistinctive == true
                        }.map {$0.value}
                        
                        if color == selectedColor {
                            return size
                        }else{
                            return nil
                        }
                        
                    })
                    
                    
                    VStack {
                        
                        ForEach(allSizes,id: \.self) { size in
                            
                            let isAvailable = availableSizes.contains(size)
                            let notStock = stockSizes.contains(size)
                            Divider()
                            
                            Button {
                                
                                
                                isShowingPopup  = false
                                navigationManager.isMainTabBarHidden = false
                                
                                
                            }label:{
                                HStack {
                                    Text(size)
                                        .opacity(isAvailable && !notStock ? 1 : 0.2)
                                        .padding(.horizontal)
                                    Spacer()
                                    Text(!isAvailable ? "ندارد" : notStock ? "تمام شده" : "موجود")
                                        .opacity(!notStock && isAvailable ? 1 : 0.2)
                                        .padding(.horizontal)
                                    
                                }.foregroundStyle(.black)
                                
                            }
                            
                        }
                    }.padding(.bottom,height/12)
                }
                
                else if multipleVariantAttribute == 1 {
                    
                    
                    
                    let attributeKey1 = Set(variants.compactMap({ variant in
                        
                        variant.attributes.first(where: {$0.isDistinctive == true })?.display_name
                        
                    })).sorted()
                    
                    
                    let allSizes1 = Set(variants.compactMap({ variant in
                        
                        variant.attributes.first(where: { $0.isDistinctive == true })?.value
                        
                    })).sorted()
                    
                    
                    let availableSizes1 = Set(variants.compactMap({ variant in
                        
                        let size = variant.attributes.first(where: { $0.isDistinctive == true })?.value
                        
                        if variant.stock_quantity > 0 {
                            
                            return size
                            
                        }else{
                            return nil
                        }
                        
                    })).sorted()
                    
                    
                    
                    VStack {
                        
                        HStack {
                            Spacer()
                            Text("\(distinctiveName) مورد نظر رو انتخاب کنید")
                                .font(.custom("DoranNoEn-Bold",size:16))
                                .foregroundStyle(.black)
                                .padding(.horizontal)
                                .padding(.vertical,10)
                            Spacer()
                        }
                        
                        ForEach(allSizes1,id: \.self) { size in
                            
                            Divider()
                            
                            Button {
                                
                                isShowingPopup  = false
                                navigationManager.isMainTabBarHidden = false
                                
                                
                            }label:{
                                
                                Text(size)
                                    .foregroundStyle(.black)
                                
                            }
                            
                        }
                    }.padding(.bottom,height/12)
                }
                
                else if multipleVariantAttribute == 1 {
                    
                    
                    
                    let attributeKey1 = Set(variants.compactMap({ variant in
                        
                        variant.attributes.first(where: {$0.isDistinctive == true })?.display_name
                        
                    })).sorted()
                    
                    
                    let allSizes1 = Set(variants.compactMap({ variant in
                        
                        variant.attributes.first(where: { $0.isDistinctive == true })?.value
                        
                    })).sorted()
                    
                    
                    let availableSizes1 = Set(variants.compactMap({ variant in
                        
                        let size = variant.attributes.first(where: { $0.isDistinctive == true })?.value
                        
                        if variant.stock_quantity > 0 {
                            
                            return size
                            
                        }else{
                            return nil
                        }
                        
                    })).sorted()
                    
                    
                    
                    VStack {
                        
                        HStack {
                            Spacer()
                            Text("\(distinctiveName) مورد نظر رو انتخاب کنید")
                                .font(.custom("DoranNoEn-Bold",size:16))
                                .foregroundStyle(.black)
                                .padding(.horizontal)
                                .padding(.vertical,10)
                            Spacer()
                        }
                        
                        ForEach(allSizes1,id: \.self) { size in
                            
                            Divider()
                            
                            Button {
                                
                                isShowingPopup  = false
                                navigationManager.isMainTabBarHidden = false
                                
                                
                            }label:{
                                
                                Text(size)
                                    .foregroundStyle(.black)
                                
                            }
                            
                        }
                    }.padding(.bottom,height/12)
                    
                } else {
                    VStack {
                        Text("No variants available")
                            .padding()
                    }
                }
                
                Spacer()
            } else {
                VStack {
                    Text("محصول در دسترس نیست")
                        .padding()
                }
            }
        }
        .padding(.bottom,60)
        .background(CustomBlurView(effect: .systemUltraThinMaterial))
        .offset(y: isShowing ? 0 : 200)
        .frame(height:height/5)
        .animation(.easeInOut(duration: 0.6), value: isShowing)
   
    }
    
    
    //MARK: - VARIANT SELECTOR
    @ViewBuilder
    func VariantSelectorView(product:ProductTest, width:CGFloat,widthColor:CGFloat,widthSize:CGFloat) -> some View {
        
        
        
        
        VStack{
            
            
            
            
            
            if multipleVariantAttribute > 1 {
                VStack(spacing:height/80) {
                    HStack(spacing:0) {
                        Spacer()
                        
                        let DistinctiveNameAttribute = Set((product.variants ?? []).compactMap({ variant in
                            variant.attributes.first(where:{ $0.isDistinctive == true })?.display_name
                            
                        })).sorted()
                        
                        
                        Text((DistinctiveNameAttribute.first ?? "ویژگی پیدا نشد") + ":")
                            .font(.custom("AbarHighNoEn-SemiBold", size: widthColor, relativeTo: .body))
                            .padding(.trailing,width/50)
                            .onAppear {
                                distinctiveName = DistinctiveNameAttribute.first ?? "NOT FOUND!"
                            }
                        
                        
                    }
                    ScrollView(.horizontal) {
                        HStack(spacing: 18) {
                            Spacer()
                            
                            let DistinctiveAttribute = Set((product.variants ?? []).compactMap({ variant in
                                variant.attributes.first(where: { $0.isDistinctive == true })?.value
                            })).sorted()
                            
                            ForEach(Array(DistinctiveAttribute), id: \.self) { variant in
                                Button {
                                    selectedColor = variant
                                    currentIndex = 0
                                } label: {
                                    Text(variant)
                                        .opacity(selectedColor == variant ? 1 : 0.2)
                                        .foregroundStyle(.black)
                                        .font(.custom("AbarHighNoEn-SemiBold", size: widthColor, relativeTo: .body))
                                }
                            }
                        }
                        .padding(.trailing,width/20)
                        .frame(minWidth: UIScreen.main.bounds.width)
                        
                    }
                    
                }
                
                HStack {
                    
                    
                    let allSizes = Set((product.variants ?? []).compactMap({ variant in
                        variant.attributes.first(where: { $0.isDistinctive == false })?.value
                    })).sorted()
                    
                    
                    let availableSizes = (product.variants ?? []).compactMap({ variant in
                        let color = variant.attributes.first(where: { $0.isDistinctive == true })?.value
                        let size = variant.attributes.first(where: { $0.isDistinctive == false })?.value
                        
                        if color == selectedColor {
                            return size
                        }
                        return nil
                    }).sorted()
                    
                    let availableStock = (product.variants ?? []).compactMap({ variant in
                        let color = variant.attributes.first(where: { $0.isDistinctive == true })?.value
                        let size = variant.attributes.first(where: { $0.isDistinctive == false })?.value
                        let stockAvailable = variant.stock_quantity > 0
                        
                        if color == selectedColor && !stockAvailable {
                            return size
                        }else{
                            return nil
                        }
                    })
                    
                    ForEach(allSizes, id: \.self) { size in
                        let isAvailable = availableSizes.contains(size)
                        let isAvailableStock = availableStock.contains(size)
                        
                        Text(size)
                            .overlay {
                                isAvailableStock ?
                                Rectangle()
                                    .frame(width: widthSize*1.6, height: 1)
                                    .rotationEffect(.degrees(45)) : nil
                            }
                            .opacity(isAvailable ? 1 : 0.2)
                            .font(.custom("Neue Metana", size: widthSize, relativeTo: .body).bold())
                            .opacity(!isAvailableStock ? 1 : 0.2)
                    }
                    
                    
                    Spacer()
                }
                .padding(.leading,12)
                .onAppear {
                    isDefaultAssigning()
                    updateImagesForSelectedColor()
                }
                .onChange(of: selectedColor) { _ in
                    updateImagesForSelectedColor()
                }
                
                
                
            }
            
            else if multipleVariantAttribute == 1 {
                
                HStack(spacing:0) {
                    Spacer()
                    
                    let DistinctiveNameAttribute = Set((product.variants ?? []).compactMap({ variant in
                        variant.attributes.first(where:{ $0.isDistinctive == true })?.display_name
                        
                    })).sorted()
                    
                    
                    Text((DistinctiveNameAttribute.first ?? "ویژگی پیدا نشد") + ":")
                        .font(.custom("AbarHighNoEn-SemiBold", size: widthColor, relativeTo: .body))
                        .padding(.trailing,width/50)
                        .onAppear {
                            distinctiveName = DistinctiveNameAttribute.first ?? "NOT FOUND!"
                        }
                    
                    
                }
                
                let attributeKey = Set(product.variants?.compactMap({ variant in
                    
                    variant.attributes.first(where: {$0.isDistinctive == true })?.display_name
                    
                }) ?? []).sorted()
                
                
                let allSizes = Set((product.variants ?? []).compactMap({ variant in
                    
                    variant.attributes.first(where: { $0.isDistinctive == true })?.value
                    
                })).sorted()
                
                
                let availableSizes = Set((product.variants ?? []).compactMap({ variant in
                    
                    let size = variant.attributes.first(where: { $0.isDistinctive == true })?.value
                    
                    if variant.stock_quantity > 0 {
                        
                        return size
                        
                    }else{
                        return nil
                    }
                    
                    
                    
                })).sorted()
                
                
                
                HStack {
                    
                    
                    ForEach(allSizes,id:\.self) { size in
                        
                        let allsizesCheck = availableSizes.contains(size)
                        
                        Text(size)
                            .opacity(allsizesCheck ? 1 : 0.2)
                            .onAppear {
                                attributeName = attributeKey.first ?? ""
                            }
                    }
                }
                
                
                
                
            }else if multipleVariantAttribute == 0 {
                
                Text("No Variants")
                
            }
        }
    }
    
    
    func isDefaultAssigning() {
        if let product = viewModel.product,
           let variants = product.variants,
           let defaultVariant = variants.first(where:{$0.is_default}) {
            let distinctiveAttribute = defaultVariant.attributes.first(where:{ $0.isDistinctive ?? false })?.value
            selectedColor = distinctiveAttribute ?? ""
        }
    }
    
    
    //MARK: - PRICE VIEW
    @ViewBuilder
    private func price() -> some View {
        HStack {
            
            //                                        VariantSelectorView(product: product)
            
            Spacer()
            
            if let product = viewModel.product {
                VStack(alignment:.trailing,spacing:0) {
                    //                                            Text("\(product.variants![0].sku)")
                    //                                                .font(.custom("AvenirNext-Bold", size: width/20))
                    //                                                .lineLimit(nil)
                    HStack {
                        Text("قیمت:  ")
                            .font(.custom("DoranNoEn-Bold", size: width/28))
                        + Text(product.getFormattedPrice().persianDigits)
                            .font(.custom("DoranNoEn-Medium", size: width/28))
                    }
                    
                    
                    Button {
                        Task {
                            try await basketVM.addToBasket(productId: product.id)
                        }
                        navigationManager.isMainTabBarHidden = true
                        isShowingPopup = true
                        
                    }label:{
                        Text("خرید")
                            .font(.custom("DoranNoEn-Bold", size: width/28))
                    }
                    
                    
                }
                .padding(.trailing,width/50)
            }
            
        }
    }
    
    
    //MARK: - ATTRIBUTE DISPLAY
    @ViewBuilder
    private func attribute_Display() -> some View {
        
        HStack(spacing: 0) {
            
            // First VStack - Textile
            VStack(spacing: 4) { // Small spacing between image and text
                ZStack {
                    Image("textilemainicon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width/24, height: height/24)
                }
                .frame(width: width/16, height: height/16)
                .frame(maxHeight: height/16) // Constrain the image container height
                
                Text(viewModel.product?.display_attributes?[0].value ?? "")
                    .font(.custom("AbarHighNoEn-SemiBold", size: 14, relativeTo: .body))
                    .multilineTextAlignment(.center) // Center align multi-line text
                    .lineLimit(nil) // Allow unlimited lines
                    .fixedSize(horizontal: false, vertical: true) // Allow vertical expansion
                    .frame(maxWidth: width/4 - 8) // Constrain width with padding
            }
            .frame(width: width/3)
            .frame(maxHeight: .infinity, alignment: .top) // Align content to top
            
            Divider()
            
            // Second VStack - Shirt
            VStack(spacing: 4) {
                ZStack {
                    Image("shirtmainicon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width/20, height: height/20)
                }
                .frame(width: width/16, height: height/16)
                .frame(maxHeight: height/16) // Constrain the image container height
                
                Text(viewModel.product?.display_attributes?.indices.contains(1) == true ? (viewModel.product?.display_attributes?[1].value ?? "") : "")
                    .font(.custom("AbarHighNoEn-SemiBold", size: 14, relativeTo: .body))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: width/6 - 8)
            }
            .frame(width: width/3)
            .frame(maxHeight: .infinity, alignment: .top)
            
            Divider()
                .background(Color.white)
            
            // Third VStack - Hands
            VStack(spacing: 4) {
                ZStack {
                    Image("handsmainicon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width/16, height: height/16)
                }
                .frame(width: width/16, height: height/16)
                .frame(maxHeight: height/16) // Constrain the image container height
                
                Text(viewModel.product?.display_attributes?.indices.contains(2) == true ? (viewModel.product?.display_attributes?[2].value ?? "") : "")
                    .font(.custom("AbarHighNoEn-SemiBold", size: 14, relativeTo: .body))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: width/6 - 8)
            }
            .frame(width: width/3)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .padding(.leading,10)
        .frame(width: width/2)
        .scaleEffect(0.9)
    }
    
        
    
    //MARK: - ADD TO WISHLIST
    @ViewBuilder
    private func addToWishlist() -> some View {
        VStack {
            Spacer()
            HStack(spacing:3) {
                Button {
                    guard let product = viewModel.product else { return }
                    
                    isButtonDisabled = true
                    
                    if isLiked {
                        
                        Task {
                            if try await viewModel.removeFromWishlist(product) {
                                isLiked = false
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    isDeleteTapped = true
                                }
                                
                                // Reset isTapped to false after 1 second
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        isDeleteTapped = false
                                    }
                                    isButtonDisabled = false
                                }
                                
                            }else{
                                isLiked = true
                                isButtonDisabled = false
                                
                            }
                        }
                        
                        
                        
                    }else{
                        
                        Task {
                            do {
                                isButtonDisabled  = true
                                guard let product = viewModel.product else {
                                    isButtonDisabled = false
                                    return
                                }
                                
                                wishlistState = .adding
                                
                                // ← This is where you'll see the prints from inside the function
                                let response = try await viewModel.addToWishlist(product)
                                
                                if response {
                                    
                                    wishlistState = .success(message: "Added to wishlist")
                                                                        // Haptic feedback
                                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                    impactFeedback.impactOccurred()
                                    
                                    // Animation
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        isLiked.toggle()
                                    }
                                    
                                    // Scale animation
                                    withAnimation(.easeInOut(duration: 0.1)) {
                                        scale1 = 1.2
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation(.easeInOut(duration: 0.1)) {
                                            scale1 = 1.0
                                        }
                                    }
                                    
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        isTapped = true
                                    }
                                    
                                    // Reset isTapped to false after 1 second
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            isTapped = false
                                        }
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                                        wishlistState = .idle
                                        isButtonDisabled = false
                                    }
                                    
                                }else{
                                    wishlistState = .failure(message: " ۲ اتصالات")
                                    isButtonDisabled = false
                                }
                                
                            } catch {
                                print("❌ Error: \(error)")
                                wishlistState = .failure(message: error.localizedDescription)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                                    viewModel.wishlistAddingStatus = .idle
                                    isButtonDisabled = false
                                }
                            }
                        }
                    }
                    
                    
                }label:{
                    
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .scaleEffect(scale1)
                        .frame(width: width/8.0, height: width/10)
                        .font(.custom("DoranNoEn-Medium", size: 26, relativeTo: .body))
                        .foregroundStyle(isLiked ? .white : .white)
                        .background(.black)
                    
                }
                .disabled(isButtonDisabled)
                
                
                
                
                Button {
                    
                }label:{
                    
                    
                    Text("افزودن به سبد خرید")
                        .frame(width:width/1.8,height: width/10)
                        .font(.custom("DoranNoEn-Medium", size: 20, relativeTo: .body))
                        .foregroundStyle(.white)
                        .background(.black)
                    
                    
                }
                
                
            }
            .padding(.bottom,height/18)
            .opacity(isScrolledDown ? 1 : 0)
            .onChange(of:isFullScreen) { newValue in
                if newValue {
                    navigationManager.isMainTabBarHidden = true
                }else{
                    navigationManager.isMainTabBarHidden = false
                }
            }
            
        }
    }
    
    
    @ViewBuilder
    private func imageTabIndicator() -> some View {
        HStack {
            if viewModel.product?.variants != [] {
                VStack(alignment:.leading,spacing: height/100) {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            
                            // Use imagesOfDisplay instead of trying to access variant directly
                            ForEach(Array(imagesOfDisplay.enumerated()), id: \.offset) { (idx, imageUrl) in
                                Rectangle()
                                    .frame(width: getDynamicWidth(for: idx), height: 1.5)
                                    .onTapGesture {
                                        withAnimation {
                                            currentIndex = idx
                                        }
                                    }
                                    .padding(.bottom, isFullScreen ? height/8 : 0)
                            }
                            
                            Spacer()
                        }
                        .frame(width:width/1, height: height / 50)
                    }
                }
            }else{
                if let product = viewModel.product {
                    VStack(alignment:.leading,spacing: height/100) {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ForEach(Array(product.images.enumerated()), id: \.element.id) { (idx, imageUrl) in
                                    Rectangle()
                                        .frame(width: getDynamicWidth(for: idx), height: 1.5)
                                        .onTapGesture {
                                            withAnimation {
                                                currentIndex = idx
                                            }
                                        }
                                        .padding(.bottom, isFullScreen ? height/8 : 0)
                                }
                                
                                Spacer()
                            }
                            .frame(width:width/1, height: height / 50)
                        }
                    }
                }
            }
        }
        .frame(width:width)
    }
    
    
    @ViewBuilder
    private func imageTab(geometry:GeometryProxy,proxy:ScrollViewProxy) -> some View {
        
        
        VStack {
            
            ZStack {
                
                TabView(selection: $currentIndex) {
                    ForEach(cachedImages.indices, id: \.self) { idx in
                        GeometryReader { geometry in
                            
                            Image(uiImage: cachedImages[idx])
                            
                                .resizable()
                                .clipped()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width,
                                       height: geometry.frame(in: .global).minY - initialGeo <= 0 ?
                                       geometry.size.width * 4/3 :
                                        geometry.size.width * 4/3 + geometry.frame(in: .global).minY - initialGeo)
                            
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        isFullScreen = true
                                        //                                        proxy.scrollTo("hero-\(currentIndex)", anchor: .top)
                                    }
                                }.disabled(isFullScreen)
                            
                                .id("hero-\(idx)")
                            
                            
                            
                                .background(Color.black)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear
                                            .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .global).minX)
                                    }
                                )
                                .onAppear {
                                    if hasSetInitialGeo {
                                        initialGeo = geometry.frame(in: .global).minY
                                        hasSetInitialGeo = false
                                    }
                                }
                                .blur(radius: geometry.frame(in: .global).minY <= 0 ? -geometry.frame(in: .global).minY/20 : 0)
                            
                            
                        }
                        .tag(idx)
                        .clipped()
                        
                    }
                    
                }
                
            }
            
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onPreferenceChange(ScrollOffsetKey.self) { newOffset in
            updateDragProgress(newOffset)
        }
        
    }
    
    @ViewBuilder
    private func navBar() -> some View {
        VStack(spacing:0)  {
            //navbar
            VStack(spacing:0) {
                
                HStack(alignment:.center) {
                    
                    
                    
                    Spacer()
                    
                    if let product = viewModel.product {
                        Text("\(product.attributeValue(forKey: "brand") ?? "")")
                        //                            .font(.custom("DoranNoEn-ExtraBold", size: 20, relativeTo: .body))
                            .font(.custom("AbarHighNoEn-Black", size: 20, relativeTo: .body))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            if let product = viewModel.product {
                                ImageStore.shared.clear(prefix: "product-\(product.id)")
                            }
                            if let categoryID = attVM.categoryID {
                                await viewModel.changeCategory(categoryID, brand: attVM.selectedValue)
                            }
                        }
                        dismiss()
                        
                    }) {
                        Image(systemName: "chevron.left.circle.fill")
                            .resizable()
                            .frame(width: width/16, height: width/17)
                            .foregroundStyle(.black)
                    }
                    .opacity(0)
                    
                    
                }
                
            }
            //            .background(.red)
            //            .background(CustomBlurView(effect: .systemThinMaterial))
        }
        .zIndex(1)
    }
 
    
    @ViewBuilder
    private func removeFromWishList() -> some View {
        ZStack {
            // Thin material background covering the whole screen
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onAppear {
                    if catVM.selectedCatNAME == "ساعت" {
                        selectedUI = .watches
                    }
                    else if catVM.selectedCatNAME == "پارتی ترند" {
                        selectedUI = .clothes
                    }
                }
            // Your text centered on top
            
            VStack {
                // Customize appearance
                Spacer()
                Text("از دوست داشتنیا حذف شد")
                    .font(.custom("DoranNoEn-Bold", size: 16, relativeTo: .body))
                    .foregroundColor(.black)
                    .padding()
                ProgressView()
                    .scaleEffect(1.2) // Make it slightly larger
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                Spacer()
                
            }
            .frame(height:width/2.4)
            .background(CustomBlurView(effect: .systemUltraThinMaterial))
            .cornerRadius(10)
            
        }
        .opacity(isDeleteTapped ? 1 : 0)
        .zIndex(15)
        .animation(.easeInOut(duration: 0.5), value: isDeleteTapped) // Add animation
    }
    
    @ViewBuilder
    private func attributeSection() -> some View {
        HStack {
            Spacer()
            if let product = viewModel.product, let attributes = product.attributes {
                VStack(spacing:0) {
                    ForEach(attributes,id:\.self) { att in
                        HStack(spacing:0) {
                            Spacer()
                            Text("\(att.value)")
                                .font(.custom("AbarHighNoEn-Regular", size: 16, relativeTo: .body))
                                .lineLimit(nil)
                                .truncationMode(.tail)
                          
                                
                            Text(" :\(att.display_name ?? "")")
                                .font(.custom("AbarHighNoEn-SemiBold", size: 16, relativeTo: .body))
                                .lineLimit(nil)
                                .truncationMode(.tail)
                                .multilineTextAlignment(.trailing)
                                .onAppear {
                                    if att.key == "مقاوم در برابر آب" {
                                        specialAttribute = att.value
                                    }
                                }
                        }
                      
                    }
                
                }
                
                .padding(.horizontal, UIScreen.main.bounds.width / 22)
            }
        }
        Divider()
    }
    
   
    
    func updateImagesForSelectedColor() {
        print("🔍 updateImagesForSelectedColor called with selectedColor: \(selectedColor)")
        
        guard let product = viewModel.product else {
            print("⚠️ Product is nil, cannot update images")
            return
        }
        
        // Get the first variant with the selected color
        let firstVariantId = product.variants?.first(where: { variant in
            variant.attributes.contains {$0.value == selectedColor}
        })?.id
        
        selectedVariantId = firstVariantId ?? 0
        
        // Update imagesOfDisplay with variant images
        if let variantId = firstVariantId,
           let variant = product.variants?.first(where: { $0.id == variantId }) {
            
            // Get variant images
            let variantImages = variant.images.map { $0.url ?? "" }
            imagesOfDisplay = variantImages
            
            
            Task {
                await loadImagesFromURLs()
            }
        } else {
            // Fallback to product images
            imagesOfDisplay = product.images.map { $0.url ?? "" }
            print("📸 Using product images as fallback: \(imagesOfDisplay)")
            
            Task {
                await loadImagesFromURLs()
            }
        }
    }
    
    func loadImagesFromURLs() async {
        
        cachedImages.removeAll()
        
        
        let urls = imagesOfDisplay.compactMap { URL(string: $0) }
        
        if !urls.isEmpty {
            cachedImages = await ImageStore.shared.preload(urls: urls, keyPrefix: "variant-\(selectedColor)", forceRefresh: true)
            print("Successfully loaded \(cachedImages.count) images")
        } else {
            print("No valid URLs found")
        }
    }
    
    private func getDynamicWidth(for index: Int) -> CGFloat {
        let baseWidth = width / 60
        let expandedWidth = width / 7
        let nextIndex = currentIndex + 1
        let previousIndex = currentIndex - 1
        
        // Helpers
        func expanded(_ prog: CGFloat) -> CGFloat { expandedWidth - (expandedWidth * prog) }
        func nextInterpolated(_ prog: CGFloat) -> CGFloat { baseWidth + (expandedWidth * prog) }
        
        switch lastSwipeDirection {
        case .right:
            if index == currentIndex {
                return dragProgress < 0.5 ? expanded(dragProgress) : expandedWidth
            } else if index == nextIndex {
                return dragProgress < 0.5 ? nextInterpolated(dragProgress) : baseWidth
            } else {
                return baseWidth
            }
            
        case .left:
            if index == currentIndex {
                // When `temp` is used in original logic prefer it when it's set and < 0.5
                let prog = (temp < 0.5 && temp != 0) ? temp : dragProgress
                return prog < 0.5 ? expanded(prog) : expandedWidth
            } else if index == nextIndex {
                if temp < 0.5 {
                    if dragProgress < 0.5 { return baseWidth }
                    if dragProgress != 1 { return baseWidth + (expandedWidth * temp) }
                    return baseWidth
                }
                return baseWidth
            } else if index == previousIndex {
                if temp < 0.5 && temp != 0 { return baseWidth }
                return dragProgress < 0.5 ? nextInterpolated(dragProgress) : baseWidth
            } else {
                return baseWidth
            }
            
        case .none:
            return index == currentIndex ? expandedWidth : baseWidth
        }
    }
    
    private func updateDragProgress(_ newOffset: CGFloat) {
        
        let screenWidth = width
        
        let progress = newOffset.truncatingRemainder(dividingBy: screenWidth) / screenWidth
        
        
        
        if currentIndex == 1 && onceDone {
            temp = abs(-progress)
        }
        dragProgress = abs(min(max(0,1-progress),1+progress))
        
        
        
        let isNowSwipingRight = newOffset > 0
        let isNowSwipingLeft = newOffset < 0
        
        
        if isNowSwipingRight {
            
            lastSwipeDirection = .right
            
        } else if isNowSwipingLeft {
            
            
            lastSwipeDirection = .left
        
        
        }
    }
}

  
struct RightToLeftModifier1: ViewModifier {
    func body(content: Content) -> some View {
        content.environment(\.layoutDirection, .rightToLeft)
    }
}



#Preview {
    finalView(productId: ProductTest.sampleProduct.id, lastNavigation: .menu)
        .environmentObject(ProductViewModel())
        .environmentObject(CategoryViewModel())
        .environmentObject(NavigationStackManager())
        .environmentObject(shoppingBasketViewModel())
}





struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}



extension ProductViewModel {
    
    @MainActor

    func addToWishlist(_ product: ProductTest) async throws -> Bool {
        
        guard !isAdding else { return false }
        isAdding = true
        defer { isAdding = false }
        
        guard let url = URL(string: "https://myshop-backend-an7h.onrender.com/shop/api/v1/wishlist/") else {
            return false
        }
        
        guard await checkInternetConnection() else {
            throw NetworkError.noInternetConnection.toNSError()
        }
        
        let body = ["product_id": product.id]
        
        do {
            let encodedData = try JSONEncoder().encode(body)
            let request = URLRequestFunction(url: url, httpMethod: "POST", httpBody: encodedData)
            let (data, response) = try await configSetupCustom().data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown("Invalid Response").toNSError()
            }
            
            // ✅ Print the actual JSON string
            if let responseString = String(data: data, encoding: .utf8) {
                print("📋 Server Response: \(responseString)")
            } else {
                print("⚠️ Could not convert response to string")
            }
            
            // ✅ Check status code
            print("📊 Status Code: \(httpResponse.statusCode)")
            
            // ✅ Try to decode the response to see the actual structure
            if let error = NetworkError.from(httpStatusCode: httpResponse.statusCode) {
                // If there's an error status code, still try to decode to see error message
                if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data) {
                    print("❌ Error Response: \(errorResponse)")
                }
                throw error.toNSError()
            }
            
            // ✅ Try to decode as WishlistResponse to see the actual response
            do {
                let wishlistResponse = try JSONDecoder().decode(WishlistResponse.self, from: data)
                print("✅ Decoded Response:")
                print("   Success: \(wishlistResponse.success)")
                print("   Message: \(wishlistResponse.message)")
                print("   Action: \(wishlistResponse.action)")
                resultWishlist = wishlistResponse.success
                return wishlistResponse.success
                
            } catch {
                print("⚠️ Could not decode as WishlistResponse: \(error)")
                // If decoding fails but status is 200/201, still return true
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                    return true
                }
                throw error
            }
            
        } catch {
            if let urlerror = error as? URLError {
                throw NetworkError.from(urlerror).toNSError()
            }
            print("❌ Error: \(error.localizedDescription)")
            throw error
            // ❌ Remove `return false` - it's unreachable after throw
        }
    }
    
    @MainActor
    func removeFromWishlist(_ product: ProductTest) async throws -> Bool {
        
        guard !isRemoving else { return false }
        isRemoving = true
        defer { isRemoving = false }
        
        guard await checkInternetConnection() else {
            throw NetworkError.noInternetConnection.toNSError()
        }
        
        guard let url  = URL(string:  "https://myshop-backend-an7h.onrender.com/shop/api/v1/wishlist/product/\(product.id)/") else {return false}
        
        do {
            
            let request = URLRequestFunction(url: url, httpMethod: "DELETE")
            
            let (data, response) = try await configSetupCustom().data(for: request)
            
            return true
            
        }catch {
            if let urlerror = error as? URLError {
                throw NetworkError.from(urlerror).toNSError()
            }
            print("❌ Error: \(error.localizedDescription)")
            throw error
            return false
        }
    }
    
    @MainActor
    func checkWishlistItem(_ product: ProductTest) async throws -> Bool {
        
        guard !isChecking else { return false }
        isChecking = true
        defer { isChecking = false }
        
        guard await checkInternetConnection() else {
            throw NetworkError.noInternetConnection.toNSError()
        }
        
        guard let url  = URL(string:  "https://myshop-backend-an7h.onrender.com/shop/api/v1/wishlist/status/?product_ids=\(product.id)") else {return false}
        
        
        
        do {
            
            let request = URLRequestFunction(url: url, httpMethod: "GET")
            
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            
            let wishlistCheckResponse = try JSONDecoder().decode(wishlistCheckId.self, from: data)
            
            let isInWishlist = wishlistCheckResponse.wishlist_status["\(product.id)"] ?? false
            print("Product \(product.id) is \(isInWishlist ? "in" : "not in") wishlist")
            
            return wishlistCheckResponse.wishlist_status["\(product.id)"] ?? false
            
            
        }catch {
            if let urlerror = error as? URLError {
                throw NetworkError.from(urlerror).toNSError()
            }
            print("❌ Error: \(error.localizedDescription)")
            throw error
            return false
        }
    }
}

// Key to track scroll offset
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


struct SimilarProductsPositionKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
