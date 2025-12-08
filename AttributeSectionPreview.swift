import SwiftUI

// MARK: - Preview View for attributeSection
struct AttributeSectionPreview: View {
    @State private var specialAttribute: String = ""
    
    // Mock product with attributes
    let mockProduct: MockProduct
    
    var body: some View {
        VStack {
            Text("Attribute Section Preview")
                .font(.headline)
                .padding()
            
            attributeSection()
            
            if !specialAttribute.isEmpty {
                Text("Special Attribute: \(specialAttribute)")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding()
            }
        }
    }
    
    @ViewBuilder
    private func attributeSection() -> some View {
        HStack {
            Spacer()
            
            if let attributes = mockProduct.attributes {
                VStack(spacing: 8) {
                    ForEach(attributes, id: \.self) { att in
                        HStack(spacing: 0) {
                            Spacer()
                            
                            Text("\(att.value)")
                                .font(.custom("AbarHighNoEn-SemiBold", size: 20, relativeTo: .body))
                                .lineLimit(nil)
                                .truncationMode(.tail)
                            
                            Text(" :\(att.key)")
                                .font(.custom("AbarHighNoEn-SemiBold", size: 20, relativeTo: .body))
                                .lineLimit(nil)
                                .truncationMode(.tail)
                                .multilineTextAlignment(.trailing)
                                .onAppear {
                                    if att.key == "مقاوم در برابر آب" {
                                        specialAttribute = att.value
                                    }
                                }
                        }
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, UIScreen.main.bounds.width / 22)
            }
        }
        Divider()
    }
}

// MARK: - Mock Models
struct MockProductAttribute: Hashable, Codable {
    let key: String
    let value: String
}

struct MockProduct {
    let id: Int?
    let name: String
    let attributes: [MockProductAttribute]?
}

// MARK: - Alternative Version with ViewModel Pattern
struct AttributeSectionWithViewModelPreview: View {
    @State private var specialAttribute: String = ""
    @StateObject private var viewModel = MockProductViewModel()
    
    var body: some View {
        VStack {
            Text("Attribute Section with ViewModel")
                .font(.headline)
                .padding()
            
            attributeSection()
            
            if !specialAttribute.isEmpty {
                Text("Special Attribute: \(specialAttribute)")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding()
            }
        }
    }
    
    @ViewBuilder
    private func attributeSection() -> some View {
        HStack {
            Spacer()
            
            if let product = viewModel.product, let attributes = product.attributes {
                VStack(spacing: 8) {
                    ForEach(attributes, id: \.self) { att in
                        HStack(spacing: 0) {
                            Spacer()
                            
                            Text("\(att.value)")
                                .font(.custom("AbarHighNoEn-SemiBold", size: 20, relativeTo: .body))
                                .lineLimit(nil)
                                .truncationMode(.tail)
                            
                            Text(" :\(att.key)")
                                .font(.custom("AbarHighNoEn-SemiBold", size: 20, relativeTo: .body))
                                .lineLimit(nil)
                                .truncationMode(.tail)
                                .multilineTextAlignment(.trailing)
                                .onAppear {
                                    if att.key == "مقاوم در برابر آب" {
                                        specialAttribute = att.value
                                    }
                                }
                        }
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, UIScreen.main.bounds.width / 22)
            }
        }
        Divider()
    }
}

// Mock ViewModel
class MockProductViewModel: ObservableObject {
    @Published var product: MockProduct?
    
    init() {
        // Initialize with sample data
        self.product = MockProduct(
            id: 1,
            name: "Test Product",
            attributes: [
                MockProductAttribute(key: "رنگ", value: "قرمز"),
                MockProductAttribute(key: "سایز", value: "متوسط"),
                MockProductAttribute(key: "مقاوم در برابر آب", value: "بله"),
                MockProductAttribute(key: "جنس", value: "پنبه"),
                MockProductAttribute(key: "برند", value: "نمونه")
            ]
        )
    }
}

// MARK: - Preview
#Preview("With Attributes") {
    AttributeSectionPreview(
        mockProduct: MockProduct(
            id: 1,
            name: "Test Product",
            attributes: [
                MockProductAttribute(key: "رنگ", value: "قرمز"),
                MockProductAttribute(key: "سایز", value: "متوسط"),
                MockProductAttribute(key: "مقاوم در برابر آب", value: "بله"),
                MockProductAttribute(key: "جنس", value: "پنبه"),
                MockProductAttribute(key: "برند", value: "نمونه")
            ]
        )
    )
}

#Preview("With ViewModel Pattern") {
    AttributeSectionWithViewModelPreview()
}

#Preview("Empty Attributes") {
    AttributeSectionPreview(
        mockProduct: MockProduct(
            id: 2,
            name: "Product Without Attributes",
            attributes: nil
        )
    )
}

#Preview("Single Attribute") {
    AttributeSectionPreview(
        mockProduct: MockProduct(
            id: 3,
            name: "Product With One Attribute",
            attributes: [
                MockProductAttribute(key: "رنگ", value: "آبی")
            ]
        )
    )
}

