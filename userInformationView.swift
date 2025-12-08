import SwiftUI

// MARK: - Modern Keyboard Height Solutions

// ✅ OPTION 1: iOS 15+ - Using keyboardLayoutGuide (BEST - Official Apple Solution)
@available(iOS 15.0, *)
class ModernKeyboardResponder: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    
    init() {
        // Use UIResponder.keyboardLayoutGuide for automatic tracking
        // This is the official modern way - no NotificationCenter needed!
    }
}

// ✅ OPTION 2: iOS 14+ - Using GeometryReader with Safe Area (RECOMMENDED)
// No class needed! Just use this in your view:
struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, keyboardHeight)
                .onAppear {
                    // Read initial safe area
                    keyboardHeight = geometry.safeAreaInsets.bottom
                }
                .onChange(of: geometry.safeAreaInsets.bottom) { newValue in
                    // Automatically updates when keyboard appears/disappears
                    keyboardHeight = newValue
                }
        }
    }
}

extension View {
    func keyboardAware() -> some View {
        modifier(KeyboardAwareModifier())
    }
}

// ✅ OPTION 3: Simplified NotificationCenter (CLEANER than your current)
class KeyboardResponder2: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    private var observers: [NSObjectProtocol] = []
    
    init() {
        // Store observers for proper cleanup
        let showObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.updateKeyboardHeight(from: notification)
        }
        
        let hideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.keyboardHeight = 0
        }
        
        observers = [showObserver, hideObserver]
    }
    
    private func updateKeyboardHeight(from notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        // Convert keyboard frame to window coordinates
        let keyboardFrameInWindow = window.convert(keyboardFrame, from: nil)
        let keyboardHeightInWindow = window.bounds.height - keyboardFrameInWindow.minY
        
        // Only update if keyboard is actually visible
        keyboardHeight = max(0, keyboardHeightInWindow)
    }
    
    deinit {
        observers.forEach { NotificationCenter.default.removeObserver($0) }
    }
}

// MARK: - CHANGEPASS Section with Modern Keyboard Handling
@ViewBuilder
func CHANGEPASS(
    currentPassword: Binding<String>,
    newPassword: Binding<String>,
    showPassword: Binding<Bool>,
    showNewPassword: Binding<Bool>,
    isChangingPasswordTapped: Binding<Bool>,
    keyboard: KeyboardResponder2,
    authVM: AuthViewModel,
    height: CGFloat
) -> some View {
    VStack {
        Text("برای تغییر پسورد ابتدا پسورد فعلی و سپس پسورد جدید را وارد کنید")
            .font(.custom("DoranNoEn-Medium", size: 14, relativeTo: .body))
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
        
        ZStack {
            // Placeholder (left-aligned, only shown when empty)
            if currentPassword.wrappedValue.isEmpty {
                HStack {
                    Spacer()
                    Text("پسورد فعلی")
                        .multilineTextAlignment(.trailing)
                        .padding(.leading)
                        .padding(.trailing)
                        .foregroundColor(.gray.opacity(0.6))
                        .font(.custom("DoranNoEn-Medium", size: 20, relativeTo: .body))
                }
                .allowsHitTesting(false) // Important: allows taps to pass through
            }
            
            HStack {
                Spacer()
                
                Button(action: { showPassword.wrappedValue.toggle() }) {
                    Image(systemName: showPassword.wrappedValue ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                        .background(.white)
                }
                .padding(.trailing)
                .opacity(currentPassword.wrappedValue.isEmpty ? 0 : 1)
            }
            .zIndex(15)
            
            // TextField (right-aligned)
            if !showPassword.wrappedValue {
                SecureField("", text: currentPassword)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                    .lineLimit(1) // Prevent multi-line
                    .baselineOffset(-3) // Adjust if needed (try -1 or 1)
            } else {
                TextField("", text: currentPassword)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.85, height: height/28)
        .font(.custom("DoranNoEn-Medium", size: 20, relativeTo: .body))
        .disableAutocorrection(true)
        .textInputAutocapitalization(.never)
        .clipShape(Capsule())
        .overlay {
            Rectangle()
                .stroke(style: StrokeStyle(lineWidth: 1))
        }
        .padding(.horizontal)
        
        ZStack {
            // Placeholder (left-aligned, only shown when empty)
            if newPassword.wrappedValue.isEmpty {
                HStack {
                    Spacer()
                    Text("پسورد جدید")
                        .multilineTextAlignment(.trailing)
                        .padding(.leading)
                        .padding(.trailing)
                        .foregroundColor(.gray.opacity(0.6))
                        .font(.custom("DoranNoEn-Medium", size: 20, relativeTo: .body))
                }
                .allowsHitTesting(false) // Important: allows taps to pass through
            }
            
            HStack {
                Spacer()
                
                Button(action: { showNewPassword.wrappedValue.toggle() }) {
                    Image(systemName: showNewPassword.wrappedValue ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                        .background(.white)
                }
                .padding(.trailing)
                .opacity(newPassword.wrappedValue.isEmpty ? 0 : 1)
            }
            .zIndex(15)
            
            // TextField (right-aligned)
            if !showNewPassword.wrappedValue {
                SecureField("", text: newPassword)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                    .lineLimit(1) // Prevent multi-line
                    .baselineOffset(-3) // Adjust if needed (try -1 or 1)
            } else {
                TextField("", text: newPassword)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.85, height: height/28)
        .font(.custom("DoranNoEn-Medium", size: 20, relativeTo: .body))
        .disableAutocorrection(true)
        .textInputAutocapitalization(.never)
        .clipShape(Capsule())
        .overlay {
            Rectangle()
                .stroke(style: StrokeStyle(lineWidth: 1))
        }
        .padding(.horizontal)
        
        Button {
            Task {
                try await authVM.changePassword(oldPassword: currentPassword.wrappedValue, newPassword: newPassword.wrappedValue)
                isChangingPasswordTapped.wrappedValue = true
            }
        } label: {
            Text("بررسی و ذخیره پسورد")
                .font(.custom("DoranNoEn-Medium", size: 18))
                .foregroundColor(.black)
        }
    }
    .padding(.top, height * 0.06)
    .padding(.bottom, keyboard.keyboardHeight)
    .opacity(isChangingPasswordTapped.wrappedValue ? 1 : 1)
    .frame(maxWidth: .infinity, maxHeight: .infinity,
           alignment: isChangingPasswordTapped.wrappedValue ? .top : .center)
}

// MARK: - User Information View
struct userInformationView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var userInformation: AuthViewModel.UserInfo?
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var alertText: String?
    @State private var alertIsShowing: Bool = false
    @State private var loadingStartTime: Date?
    @State private var shouldShowAlert: Bool = false
    
    // Computed property that doesn't modify state - safe to use in view body
    private var alertOpacity: Double {
        shouldShowAlert ? 1 : 0
    }
    
    var body: some View {
        VStack {
            // Your view content here
            Text("User Information")
        }
        .onAppear {
            Task {
                do {
                    try await authVM.loadUserData()
                    
                    userInformation = authVM.user
                    
                    // Initialize state variables from loaded data
                    if let userInfo = userInformation {
                        name = userInfo.first_name
                        surname = userInfo.last_name
                        email = userInfo.email
                        phone = userInfo.phone_number ?? ""
                    }
                    
                } catch {
                    alertText = "خطا در بارگذاری اطلاعات"
                    alertIsShowing = true
                }
            }
        }
        // ✅ FIX: Watch for loading state changes and update state in onChange handler
        .onChange(of: authVM.isLoading) { isLoading in
            handleLoadingStateChange(isLoading: isLoading)
        }
        .alert(alertText ?? "", isPresented: $alertIsShowing) {
            Button("OK", role: .cancel) {}
        }
    }
    
    // ✅ FIX: Separate function that modifies state - called from onChange, not during view rendering
    private func handleLoadingStateChange(isLoading: Bool) {
        if isLoading {
            loadingStartTime = Date()
            alertText = "درحال بارگذاری اطلاعات کاربری..."
            shouldShowAlert = true
            alertIsShowing = true
            
        } else {
            guard let startTime = loadingStartTime else {
                shouldShowAlert = false
                alertIsShowing = false
                return
            }
            
            let elapsed = Date().timeIntervalSince(startTime)
            let minimumDuration = 2.0
            
            if elapsed >= minimumDuration {
                alertText = nil
                shouldShowAlert = false
                alertIsShowing = false
            } else {
                let remainingTime = minimumDuration - elapsed
                DispatchQueue.main.asyncAfter(deadline: .now() + remainingTime) {
                    alertText = nil
                    shouldShowAlert = false
                    alertIsShowing = false
                }
            }
        }
    }
}

// MARK: - EVEN BETTER: Use SwiftUI's built-in modifier (iOS 14+)
// Just replace your VStack with this - NO keyboard class needed!
/*
VStack {
    // ... your content ...
}
.ignoresSafeArea(.keyboard, edges: .bottom)
.scrollDismissesKeyboard(.interactively)
*/
can