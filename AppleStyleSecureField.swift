import SwiftUI

// MARK: - Apple-Style Secure Text Field
// Shows last character for a few seconds before hiding it, just like iOS
struct AppleStyleSecureField: View {
    @Binding var text: String
    let placeholder: String
    let showLastCharDuration: TimeInterval // How long to show last char (default: 1.5 seconds)
    
    @State private var displayText: String = ""
    @State private var isRevealed: Bool = false
    @State private var showPasswordToggle: Bool = false
    @FocusState private var isFocused: Bool
    
    init(text: Binding<String>, placeholder: String, showLastCharDuration: TimeInterval = 1.5) {
        self._text = text
        self.placeholder = placeholder
        self.showLastCharDuration = showLastCharDuration
    }
    
    var body: some View {
        HStack {
            ZStack(alignment: .trailing) {
                // Placeholder
                if text.isEmpty && !isFocused {
                    Text(placeholder)
                        .foregroundColor(.gray.opacity(0.6))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Secure/Revealed Text Field
                Group {
                    if isRevealed {
                        // Show actual text when revealed
                        TextField("", text: $text, prompt: Text(""))
                            .multilineTextAlignment(.trailing)
                    } else {
                        // Show masked text with last char visible
                        TextField("", text: .constant(displayText), prompt: Text(""))
                            .multilineTextAlignment(.trailing)
                            .disabled(true) // Prevent direct editing
                            .overlay(
                                // Invisible TextField for input
                                TextField("", text: $text)
                                    .opacity(0)
                                    .onChange(of: text) { newValue in
                                        handleTextChange(newValue: newValue)
                                    }
                            )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            // Show/Hide Password Toggle Button
            if !text.isEmpty {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isRevealed.toggle()
                        if isRevealed {
                            displayText = text
                        } else {
                            updateDisplayText()
                        }
                    }
                }) {
                    Image(systemName: isRevealed ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .focused($isFocused)
        .onAppear {
            updateDisplayText()
        }
    }
    
    private func handleTextChange(newValue: String) {
        let oldLength = displayText.replacingOccurrences(of: "•", with: "").count
        let newLength = newValue.count
        
        if newLength > oldLength {
            // Character was added - show it briefly
            showLastCharacter(newValue: newValue, lastIndex: newLength - 1)
        } else if newLength < oldLength {
            // Character was deleted
            updateDisplayText()
        }
    }
    
    private func showLastCharacter(newValue: String, lastIndex: Int) {
        // Create display text with last char visible
        let masked = String(repeating: "•", count: max(0, lastIndex))
        let lastChar = String(newValue[newValue.index(newValue.startIndex, offsetBy: lastIndex)])
        displayText = masked + lastChar
        
        // Hide last char after duration
        DispatchQueue.main.asyncAfter(deadline: .now() + showLastCharDuration) {
            // Only hide if text hasn't changed and we're not revealed
            if !isRevealed && text.count == newValue.count {
                updateDisplayText()
            }
        }
    }
    
    private func updateDisplayText() {
        if isRevealed {
            displayText = text
        } else {
            displayText = String(repeating: "•", count: text.count)
        }
    }
}

// MARK: - Enhanced Version with Better Visual Feedback
struct EnhancedAppleSecureField: View {
    @Binding var text: String
    let placeholder: String
    let showLastCharDuration: TimeInterval
    
    @State private var visibleChars: Set<Int> = [] // Track which chars are temporarily visible
    @State private var isRevealed: Bool = false
    @FocusState private var isFocused: Bool
    
    init(text: Binding<String>, placeholder: String, showLastCharDuration: TimeInterval = 1.5) {
        self._text = text
        self.placeholder = placeholder
        self.showLastCharDuration = showLastCharDuration
    }
    
    var body: some View {
        HStack {
            ZStack(alignment: .trailing) {
                // Placeholder
                if text.isEmpty && !isFocused {
                    Text(placeholder)
                        .foregroundColor(.gray.opacity(0.6))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Display text with masking
                if isRevealed {
                    TextField("", text: $text, prompt: Text(""))
                        .multilineTextAlignment(.trailing)
                } else {
                    Text(maskedText)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .overlay(
                            // Invisible TextField for input
                            TextField("", text: $text)
                                .opacity(0)
                                .onChange(of: text) { newValue in
                                    handleTextChange(newValue: newValue)
                                }
                        )
                }
            }
            
            // Toggle button
            if !text.isEmpty {
                Button(action: {
                    withAnimation {
                        isRevealed.toggle()
                        if !isRevealed {
                            visibleChars.removeAll()
                        }
                    }
                }) {
                    Image(systemName: isRevealed ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                }
            }
        }
        .focused($isFocused)
    }
    
    private var maskedText: String {
        guard !isRevealed else { return text }
        
        return text.enumerated().map { index, char in
            visibleChars.contains(index) ? String(char) : "•"
        }.joined()
    }
    
    private func handleTextChange(newValue: String) {
        let oldLength = text.count
        let newLength = newValue.count
        
        if newLength > oldLength {
            // New character added - show it
            let newIndex = newLength - 1
            visibleChars.insert(newIndex)
            
            // Hide it after duration
            DispatchQueue.main.asyncAfter(deadline: .now() + showLastCharDuration) {
                if !isRevealed && newValue.count == text.count {
                    visibleChars.remove(newIndex)
                }
            }
        } else if newLength < oldLength {
            // Character deleted - update visible chars
            visibleChars = visibleChars.filter { $0 < newLength }
        }
    }
}

// MARK: - Usage Example
struct SecureFieldExample: View {
    @State private var password = ""
    @State private var currentPassword = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Simple version
            AppleStyleSecureField(
                text: $password,
                placeholder: "رمز عبور را وارد کنید",
                showLastCharDuration: 1.5
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
            
            // Enhanced version
            EnhancedAppleSecureField(
                text: $currentPassword,
                placeholder: "پسورد فعلی را وارد کنید",
                showLastCharDuration: 2.0
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



