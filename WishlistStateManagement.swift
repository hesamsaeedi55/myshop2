// MARK: - Improved Wishlist State Management
// This file demonstrates a better approach to managing wishlist operation states

import SwiftUI

// MARK: - Wishlist Operation State Enum
enum WishlistOperationState {
    case idle
    case adding
    case removing
    case success(message: String)
    case error(message: String)
}

// MARK: - Usage Example in ViewModel
/*
extension ProductViewModel {
    @Published var wishlistState: WishlistOperationState = .idle
    
    @MainActor
    func addToWishlist(_ product: ProductTest) async throws -> Bool {
        wishlistState = .adding
        
        guard !isAdding else { return false }
        isAdding = true
        defer { 
            isAdding = false
            // Auto-reset after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.wishlistState = .idle
            }
        }
        
        // ... existing API call code ...
        
        do {
            let response = try await performAddToWishlist(product)
            wishlistState = .success(message: "به لیست دوست داشتنیا اضافه شد")
            return response.success
        } catch {
            wishlistState = .error(message: "خطا در انجام عملیات")
            throw error
        }
    }
    
    @MainActor
    func removeFromWishlist(_ product: ProductTest) async throws -> Bool {
        wishlistState = .removing
        
        guard !isRemoving else { return false }
        isRemoving = true
        defer { 
            isRemoving = false
            // Auto-reset after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.wishlistState = .idle
            }
        }
        
        // ... existing API call code ...
        
        do {
            let success = try await performRemoveFromWishlist(product)
            wishlistState = .success(message: "از دوست داشتنیا حذف شد")
            return success
        } catch {
            wishlistState = .error(message: "خطا در انجام عملیات")
            throw error
        }
    }
}
*/

// MARK: - Usage Example in View
/*
@ViewBuilder
private func wishlistFeedback() -> some View {
    switch viewModel.wishlistState {
    case .idle:
        EmptyView()
    case .adding:
        ProgressView()
            .padding()
    case .removing:
        ProgressView()
            .padding()
    case .success(let message):
        Text(message)
            .font(.custom("DoranNoEn-Bold", size: 16))
            .foregroundColor(.black)
            .padding()
            .background(CustomBlurView(effect: .systemUltraThinMaterial))
            .cornerRadius(10)
    case .error(let message):
        Text(message)
            .font(.custom("DoranNoEn-Bold", size: 16))
            .foregroundColor(.red)
            .padding()
            .background(CustomBlurView(effect: .systemUltraThinMaterial))
            .cornerRadius(10)
    }
}
*/



