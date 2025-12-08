import SwiftUI

// MARK: - Fixed Alignment Secure Field
struct FixedAlignmentSecureField: View {
    @Binding var text: String
    let placeholder: String
    @State private var showPassword = false
    let height: CGFloat
    
    var body: some View {
        ZStack {
            // Placeholder
            if text.isEmpty {
                HStack {
                    Spacer()
                    TextField(placeholder, text: $text)
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
                .opacity(text.isEmpty ? 0 : 1)
            }
            .zIndex(15)
            
            // TextField/SecureField with proper alignment
            HStack {
                if !showPassword {
                    SecureField("", text: $text)
                        .multilineTextAlignment(.trailing)
                        .padding(.leading)
                        .padding(.trailing, text.isEmpty ? 0 : 40)
                        .lineLimit(1) // Prevent multi-line
                        .baselineOffset(0) // Adjust if needed (try -1 or 1)
                } else {
                    TextField("", text: $text)
                        .multilineTextAlignment(.trailing)
                        .padding(.leading)
                        .padding(.trailing, text.isEmpty ? 0 : 40)
                        .lineLimit(1)
                }
            }
            .frame(height: height/24)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(width: UIScreen.main.bounds.width * 0.85, height: height/24)
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

// MARK: - Alternative: Using Vertical Alignment
struct BetterAlignedSecureField: View {
    @Binding var text: String
    let placeholder: String
    @State private var showPassword = false
    let height: CGFloat
    
    var body: some View {
        ZStack {
            // Placeholder
            if text.isEmpty {
                HStack {
                    Spacer()
                    Text(placeholder)
                        .foregroundColor(.gray.opacity(0.6))
                        .font(.custom("DoranNoEn-Medium", size: 20, relativeTo: .body))
                        .padding(.leading)
                        .padding(.trailing)
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
                .opacity(text.isEmpty ? 0 : 1)
            }
            .zIndex(15)
            
            // TextField/SecureField with center alignment
            HStack(alignment: .center) {
                Spacer()
                if !showPassword {
                    SecureField("", text: $text)
                        .multilineTextAlignment(.trailing)
                        .padding(.leading)
                        .padding(.trailing, text.isEmpty ? 0 : 40)
                        .lineLimit(1)
                } else {
                    TextField("", text: $text)
                        .multilineTextAlignment(.trailing)
                        .padding(.leading)
                        .padding(.trailing, text.isEmpty ? 0 : 40)
                        .lineLimit(1)
                }
            }
            .frame(height: height/24)
        }
        .frame(width: UIScreen.main.bounds.width * 0.85, height: height/24)
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



