import Foundation

// MARK: - Option 1: Make it Callable (Your Preferred Style)
class PasswordValidator {
    
    struct ValidationResult {
        let isValid: Bool
        let errors: [String]
        let requirements: RequirementsStatus
        
        struct RequirementsStatus {
            let hasMinLength: Bool
            let hasUppercase: Bool
            let hasLowercase: Bool
            let hasNumber: Bool
            let hasSpecialChar: Bool
        }
    }
    
    let minLength: Int
    
    init(minLength: Int = 8) {
        self.minLength = minLength
    }
    
    // ✅ Make it callable like: validator(password)
    func callAsFunction(_ password: String) -> ValidationResult {
        return validate(password)
    }
    
    // Or just use a regular method
    func validate(_ password: String) -> ValidationResult {
        var errors: [String] = []
        var requirements = ValidationResult.RequirementsStatus(
            hasMinLength: false,
            hasUppercase: false,
            hasLowercase: false,
            hasNumber: false,
            hasSpecialChar: false
        )
        
        // Check minimum length
        if password.count >= minLength {
            requirements.hasMinLength = true
        } else {
            errors.append("Password must be at least \(minLength) characters long")
        }
        
        // Check for uppercase letter
        if password.range(of: "[A-Z]", options: .regularExpression) != nil {
            requirements.hasUppercase = true
        } else {
            errors.append("Password must contain at least one uppercase letter")
        }
        
        // Check for lowercase letter
        if password.range(of: "[a-z]", options: .regularExpression) != nil {
            requirements.hasLowercase = true
        } else {
            errors.append("Password must contain at least one lowercase letter")
        }
        
        // Check for number
        if password.range(of: "[0-9]", options: .regularExpression) != nil {
            requirements.hasNumber = true
        } else {
            errors.append("Password must contain at least one number")
        }
        
        // Check for special character
        let specialCharSet = CharacterSet(charactersIn: "!@#$%^&*(),.?\":{}|<>[]-_+=~`/\\")
        let hasSpecialChar = password.unicodeScalars.contains { specialCharSet.contains($0) }
        
        if hasSpecialChar {
            requirements.hasSpecialChar = true
        } else {
            errors.append("رمزعبور باید حداقل یک کاراکتر خاص داشته باشد")
        }
        
        return ValidationResult(
            isValid: errors.isEmpty,
            errors: errors,
            requirements: requirements
        )
    }
}

// MARK: - Usage in SwiftUI (Your Preferred Style)
struct LoginBrowserView: View {
    @State private var password: String = ""
    @State private var passValidator: PasswordValidator? = PasswordValidator()
    
    var body: some View {
        VStack {
            SecureField("Password", text: $password)
            
            // ✅ Use it like you want:
            if let validator = passValidator, !validator(password).isValid {
                ForEach(validator(password).errors, id: \.self) { error in
                    Text(error)
                        .foregroundColor(.red)
                }
            }
        }
    }
}

// MARK: - Why Static is More Common (But Your Way Works Too!)

/*
 COMPARISON:

 ✅ YOUR WAY (Instance-based):
 - @State private var passValidator: PasswordValidator? = PasswordValidator()
 - passValidator?(password)
 
 PROS:
 - Can store configuration (minLength, etc.)
 - Can be passed around
 - More object-oriented
 
 CONS:
 - Extra state variable
 - Need to unwrap optional
 - More memory (though minimal)
 
 ✅ STATIC WAY (Current design):
 - PasswordValidator.validate(password)
 
 PROS:
 - No state needed
 - No instantiation
 - More functional/utility style
 - Common pattern for validators
 
 CONS:
 - Can't store configuration easily
 - Less object-oriented
 
 BOTH ARE VALID! Choose based on your preference.
 
 For validators, static is more common because:
 - Validators are usually stateless
 - No need to store instances
 - More like utility functions
 
 But if you prefer instance-based, that's totally fine!
 */


