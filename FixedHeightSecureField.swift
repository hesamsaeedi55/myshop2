import SwiftUI

// MARK: - Fixed Height Secure Field Solution
struct FixedHeightSecureField: View {
    @Binding var text: String
    let placeholder: String
    @State private var showPassword = false
    
    var body: some View {
        ZStack {
            // Placeholder (shown when empty)
            if text.isEmpty {
                HStack {
                    Spacer()
                    Text(placeholder)
                        .foregroundColor(.gray.opacity(0.6))
                        .multilineTextAlignment(.leading)
                        .padding(.leading)
                        .padding(.trailing)
                        .font(.custom("DoranNoEn-Medium", size: 20, relativeTo: .body))
                }
                .allowsHitTesting(false)
            }
            
            // Toggle button (shown when not empty)
            if !text.isEmpty {
                HStack {
                    Spacer()
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing)
                }
                .zIndex(15)
            }
            
            // TextField/SecureField with FIXED HEIGHT
            HStack {
                if !showPassword {
                    SecureField("", text: $text)
                        .multilineTextAlignment(.trailing)
                        .padding(.leading)
                        .padding(.trailing, text.isEmpty ? 0 : 40) // Extra padding for button
                } else {
                    TextField("", text: $text)
                        .multilineTextAlignment(.trailing)
                        .padding(.leading)
                        .padding(.trailing, text.isEmpty ? 0 : 40) // Extra padding for button
                }
            }
            .frame(height: 44) // FIXED HEIGHT - prevents height changes
        }
        .font(.custom("DoranNoEn-Medium", size: 20, relativeTo: .body))
        .disableAutocorrection(true)
        .textInputAutocapitalization(.never)
        .clipShape(Capsule())
        .overlay {
            Rectangle()
                .stroke(style: StrokeStyle(lineWidth: 1))
        }
    }
}

// MARK: - Your Code Fixed
struct YourFixedCode: View {
    @State private var currentPassword = ""
    @State private var showPassword = false
    
    var body: some View {
        ZStack {
            // Placeholder
            if currentPassword.isEmpty {
                HStack {
                    Spacer()
                    TextField("پسورد فعلی را وارد کنید", text: $currentPassword)
                        .multilineTextAlignment(.trailing)
                        .padding(.leading)
                        .padding(.trailing)
                        .foregroundColor(.gray.opacity(0.6))
                        .font(.custom("DoranNoEn-Medium", size: 20, relativeTo: .body))
                }
                .allowsHitTesting(false)
            }
            
            // Toggle button
            HStack {
                Spacer()
                Button(action: { showPassword.toggle() }) {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing)
                .opacity(currentPassword.isEmpty ? 0 : 1)
            }
            .zIndex(15)
            
            // TextField/SecureField with FIXED HEIGHT
            HStack {
                if !showPassword {
                    SecureField("", text: $currentPassword)
                        .multilineTextAlignment(.trailing)
                        .padding(.leading)
                        .padding(.trailing, currentPassword.isEmpty ? 0 : 40) // Space for button
                } else {
                    TextField("", text: $currentPassword)
                        .multilineTextAlignment(.trailing)
                        .padding(.leading)
                        .padding(.trailing, currentPassword.isEmpty ? 0 : 40) // Space for button
                }
            }
            .frame(height: 44) // ✅ FIXED HEIGHT - This prevents height changes
        }
        .font(.custom("DoranNoEn-Medium", size: 20, relativeTo: .body))
        .disableAutocorrection(true)
        .textInputAutocapitalization(.never)
        .clipShape(Capsule())
        .overlay {
            Rectangle()
                .stroke(style: StrokeStyle(lineWidth: 1))
        }
        .padding(.top)
        .padding(.horizontal)
    }
}



