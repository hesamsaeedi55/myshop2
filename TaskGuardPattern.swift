import SwiftUI

// MARK: - Task Guard Patterns

struct LoginView: View {
    @State private var password: String = ""
    @State private var isLoading = false
    
    private var validation: PasswordValidator.ValidationResult {
        PasswordValidator.validate(password)
    }
    
    // ============================================
    // ❌ WRONG: return inside Task doesn't work as expected
    // ============================================
    func wrongApproach() {
        Task {
            do {
                guard validation.isValid else {
                    return  // ❌ This only returns from Task closure, not the function
                }
                // try await loginViewModel.login(...)
            } catch {
                // handle error
            }
        }
    }
    
    // ============================================
    // ✅ CORRECT: Early return before Task
    // ============================================
    func correctApproach1() {
        // ✅ Check validation BEFORE Task
        guard validation.isValid else {
            print("Validation failed")
            return  // ✅ This returns from the function
        }
        
        Task {
            do {
                // try await loginViewModel.login(...)
            } catch {
                // handle error
            }
        }
    }
    
    // ============================================
    // ✅ CORRECT: Use if-else inside Task
    // ============================================
    func correctApproach2() {
        Task {
            guard validation.isValid else {
                // Show error or return early from Task
                print("Validation failed")
                return  // ✅ This returns from Task closure (which is fine)
            }
            
            do {
                // try await loginViewModel.login(...)
            } catch {
                // handle error
            }
        }
    }
    
    // ============================================
    // ✅ BEST: Check before Task + Show error
    // ============================================
    @State private var errorMessage: String?
    
    func bestApproach() {
        // ✅ Validate BEFORE creating Task
        guard validation.isValid else {
            errorMessage = validation.errors.first ?? "Please fix password errors"
            return  // ✅ Returns from function
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                // try await loginViewModel.login(email: email, password: password)
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    // ============================================
    // ✅ ALTERNATIVE: Disable button instead
    // ============================================
    var body: some View {
        VStack {
            SecureField("Password", text: $password)
            
            Button("Login") {
                // ✅ Validation already checked - button is disabled if invalid
                Task {
                    do {
                        // try await loginViewModel.login(...)
                    } catch {
                        // handle error
                    }
                }
            }
            .disabled(!validation.isValid || isLoading)  // ✅ Disable if invalid
        }
    }
}

// MARK: - Complete Example
struct CompleteLoginExample: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    // Computed validation
    private var passwordValidation: PasswordValidator.ValidationResult {
        PasswordValidator.validate(password)
    }
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            Button("Login") {
                login()
            }
            .disabled(!passwordValidation.isValid || isLoading)
        }
    }
    
    func login() {
        // ✅ BEST PRACTICE: Validate BEFORE Task
        guard passwordValidation.isValid else {
            errorMessage = passwordValidation.errors.first ?? "Please fix password errors"
            return  // ✅ Returns from function
        }
        
        // Clear previous errors
        errorMessage = nil
        isLoading = true
        
        Task {
            do {
                // try await loginViewModel.login(email: email, password: password)
                // On success:
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
}


