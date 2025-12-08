import SwiftUI

// MARK: - Custom TextField with Different Placeholder Alignment
struct CustomAlignedTextField: View {
    @Binding var text: String
    let placeholder: String
    let textAlignment: TextAlignment
    let placeholderAlignment: TextAlignment
    
    var body: some View {
        ZStack(alignment: textAlignment == .trailing ? .trailing : .leading) {
            // Placeholder (shown when text is empty)
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray.opacity(0.6))
                    .multilineTextAlignment(placeholderAlignment)
                    .frame(maxWidth: .infinity, alignment: placeholderAlignment == .trailing ? .trailing : .leading)
            }
            
            // Actual TextField
            TextField("", text: $text, prompt: Text(""))
                .multilineTextAlignment(textAlignment)
                .frame(maxWidth: .infinity, alignment: textAlignment == .trailing ? .trailing : .leading)
        }
    }
}

// MARK: - Usage Example
struct CustomAlignedTextFieldExample: View {
    @State private var currentPassword = ""
    
    var body: some View {
        VStack {
            // Example: Placeholder left-aligned, text right-aligned
            CustomAlignedTextField(
                text: $currentPassword,
                placeholder: "پسورد فعلی را وارد کنید",
                textAlignment: .trailing,  // Text input aligns right
                placeholderAlignment: .leading  // Placeholder aligns left
            )
            .font(.custom("DoranNoEn-Medium", size: 20, relativeTo: .body))
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .clipShape(Capsule())
            .overlay {
                Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 1))
            }
            .padding()
        }
    }
}

// MARK: - Alternative: Using ZStack with Manual Positioning
struct AlignedTextField: View {
    @Binding var text: String
    let placeholder: String
    let textAlignment: TextAlignment
    let placeholderAlignment: TextAlignment
    
    var body: some View {
        ZStack {
            // Background TextField (invisible prompt)
            TextField("", text: $text)
                .multilineTextAlignment(textAlignment)
                .opacity(text.isEmpty ? 0 : 1)
            
            // Placeholder overlay
            if text.isEmpty {
                HStack {
                    if placeholderAlignment == .leading {
                        Text(placeholder)
                            .foregroundColor(.gray.opacity(0.6))
                            .multilineTextAlignment(.leading)
                        Spacer()
                    } else {
                        Spacer()
                        Text(placeholder)
                            .foregroundColor(.gray.opacity(0.6))
                            .multilineTextAlignment(.trailing)
                    }
                }
                .allowsHitTesting(false) // Allow taps to pass through to TextField
            }
        }
    }
}



