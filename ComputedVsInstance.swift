import SwiftUI

// MARK: - Comparison: Computed Property vs Instance-Based

struct ComparisonExample: View {
    @State private var password: String = ""
    
    // ============================================
    // APPROACH 1: Computed Property (Better)
    // ============================================
    private var passwordValidation: PasswordValidator.ValidationResult {
        PasswordValidator.validate(password)
    }
    
    var body1: some View {
        VStack {
            SecureField("Password", text: $password)
            
            // ✅ Clean, direct access - no unwrapping needed
            if !passwordValidation.isValid {
                ForEach(passwordValidation.errors, id: \.self) { error in
                    Text(error)
                }
            }
            
            // ✅ Always up-to-date automatically
            Text("Has uppercase: \(passwordValidation.requirements.hasUppercase)")
        }
    }
    
    // ============================================
    // APPROACH 2: Instance-Based (Your Way)
    // ============================================
    @State private var passValidator: PasswordValidator? = PasswordValidator()
    
    var body2: some View {
        VStack {
            SecureField("Password", text: $password)
            
            // ❌ Need to unwrap optional every time
            if let validator = passValidator {
                let result = validator(password)
                if !result.isValid {
                    ForEach(result.errors, id: \.self) { error in
                        Text(error)
                    }
                }
            }
            
            // ❌ More verbose, need to call it manually
            if let validator = passValidator {
                Text("Has uppercase: \(validator(password).requirements.hasUppercase)")
            }
        }
    }
}

// MARK: - Why Computed Property is Better

/*
 
 ✅ COMPUTED PROPERTY ADVANTAGES:
 
 1. AUTOMATIC REACTIVITY
    - SwiftUI automatically recalculates when `password` changes
    - No manual calls needed
    - Always in sync
 
 2. NO OPTIONAL UNWRAPPING
    - Direct access: `passwordValidation.isValid`
    - No `if let` or `?` needed
    - Cleaner code
 
 3. LESS STATE
    - One less `@State` variable
    - Less memory (computed on demand)
    - Simpler state management
 
 4. CLEANER SYNTAX
    - `passwordValidation.isValid` vs `passValidator?(password).isValid`
    - More readable
    - Less boilerplate
 
 5. ALWAYS UP-TO-DATE
    - Computed property recalculates automatically
    - Instance-based requires manual calls
    - No risk of stale data
 
 ❌ INSTANCE-BASED DISADVANTAGES:
 
 1. OPTIONAL UNWRAPPING
    - Need `if let validator = passValidator` everywhere
    - More verbose code
    - Risk of forgetting to unwrap
 
 2. MANUAL CALLS
    - Must call `validator(password)` every time
    - Easy to forget to update
    - Can get out of sync
 
 3. EXTRA STATE
    - Stores validator instance (minimal, but unnecessary)
    - One more thing to manage
    - More complex
 
 4. MORE BOILERPLATE
    - More code to write
    - More places for bugs
    - Less SwiftUI-idiomatic
 
 */

// MARK: - Real-World Example

struct LoginView: View {
    @State private var password: String = ""
    
    // ✅ Computed property - clean and reactive
    private var validation: PasswordValidator.ValidationResult {
        PasswordValidator.validate(password)
    }
    
    var body: some View {
        VStack {
            SecureField("Password", text: $password)
            
            // ✅ Simple, direct access
            if !validation.isValid {
                VStack(alignment: .leading) {
                    ForEach(validation.errors, id: \.self) { error in
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
            }
            
            // ✅ Show requirements status
            VStack(alignment: .leading) {
                RequirementCheck(
                    text: "8+ characters",
                    isMet: validation.requirements.hasMinLength
                )
                RequirementCheck(
                    text: "Uppercase letter",
                    isMet: validation.requirements.hasUppercase
                )
                RequirementCheck(
                    text: "Lowercase letter",
                    isMet: validation.requirements.hasLowercase
                )
                RequirementCheck(
                    text: "Number",
                    isMet: validation.requirements.hasNumber
                )
                RequirementCheck(
                    text: "Special character",
                    isMet: validation.requirements.hasSpecialChar
                )
            }
        }
    }
}

struct RequirementCheck: View {
    let text: String
    let isMet: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isMet ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isMet ? .green : .gray)
            Text(text)
                .foregroundColor(isMet ? .primary : .secondary)
        }
    }
}


