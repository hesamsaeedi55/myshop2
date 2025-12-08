import SwiftUI

// MARK: - Professional Approach: Computed Property (Most Common)
// This is the industry standard for SwiftUI - clean, reactive, no extra state

struct LoginBrowserView: View {
    @State private var password: String = ""
    
    // ✅ PROFESSIONAL: Computed property - automatically updates when password changes
    private var passwordValidation: PasswordValidator.ValidationResult {
        PasswordValidator.validate(password)
    }
    
    var body: some View {
        VStack {
            SecureField("Password", text: $password)
            
            // Show validation errors
            if !passwordValidation.isValid {
                ForEach(passwordValidation.errors, id: \.self) { error in
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
    }
}

// MARK: - Alternative: ViewModel Pattern (For Complex Apps)
// Use this if you need validation logic shared across multiple views

class LoginViewModel: ObservableObject {
    @Published var password: String = "" {
        didSet {
            validatePassword()
        }
    }
    
    @Published var passwordValidation: PasswordValidator.ValidationResult = 
        PasswordValidator.ValidationResult(
            isValid: false,
            errors: [],
            requirements: PasswordValidator.ValidationResult.RequirementsStatus(
                hasMinLength: false,
                hasUppercase: false,
                hasLowercase: false,
                hasNumber: false,
                hasSpecialChar: false
            )
        )
    
    private func validatePassword() {
        passwordValidation = PasswordValidator.validate(password)
    }
}

struct LoginViewWithViewModel: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            SecureField("Password", text: $viewModel.password)
            
            if !viewModel.passwordValidation.isValid {
                ForEach(viewModel.passwordValidation.errors, id: \.self) { error in
                    Text(error)
                        .foregroundColor(.red)
                }
            }
        }
    }
}

// MARK: - Best Practice: Extension for Clean Code
extension View {
    /// Validates password and shows errors inline
    func passwordValidation(_ password: String) -> some View {
        let validation = PasswordValidator.validate(password)
        return VStack(alignment: .leading) {
            self
            if !validation.isValid {
                ForEach(validation.errors, id: \.self) { error in
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
    }
}


