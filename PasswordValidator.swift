import Foundation

// MARK: - Password Validation
struct PasswordValidator {
    
    // MARK: - Validation Result
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
    
    // MARK: - Validate Password
    static func validate(_ password: String, minLength: Int = 8) -> ValidationResult {
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
        
        // Check for special character (any character that is not letter or number)
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
    
    // MARK: - Quick Validation (returns Bool)
    static func isValid(_ password: String, minLength: Int = 8) -> Bool {
        return validate(password, minLength: minLength).isValid
    }
    
    // MARK: - Get Missing Requirements (for UI display)
    static func getMissingRequirements(_ password: String, minLength: Int = 8) -> [String] {
        return validate(password, minLength: minLength).errors
    }
}

// MARK: - Usage Examples
extension PasswordValidator {
    
    // Example 1: Simple validation
    static func example1() {
        let password = "MyPassword123!"
        let result = PasswordValidator.validate(password)
        
        if result.isValid {
            print("✅ Password is valid!")
        } else {
            print("❌ Password errors:")
            result.errors.forEach { print("  - \($0)") }
        }
    }
    
    // Example 2: Check individual requirements
    static func example2() {
        let password = "weak"
        let result = PasswordValidator.validate(password)
        
        print("Has uppercase: \(result.requirements.hasUppercase)")
        print("Has lowercase: \(result.requirements.hasLowercase)")
        print("Has number: \(result.requirements.hasNumber)")
        print("Has special char: \(result.requirements.hasSpecialChar)")
        print("Has min length: \(result.requirements.hasMinLength)")
    }
    
    // Example 3: Real-time validation in SwiftUI
    static func example3() {
        // In your SwiftUI view:
        /*
        @State private var password = ""
        @State private var passwordErrors: [String] = []
        
        TextField("Password", text: $password)
            .onChange(of: password) { newValue in
                let result = PasswordValidator.validate(newValue)
                passwordErrors = result.errors
            }
        */
    }
}

// MARK: - SwiftUI Helper View
import SwiftUI

struct PasswordStrengthIndicator: View {
    let password: String
    let minLength: Int
    
    var validation: PasswordValidator.ValidationResult {
        PasswordValidator.validate(password, minLength: minLength)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RequirementRow(
                text: "At least \(minLength) characters",
                isMet: validation.requirements.hasMinLength
            )
            RequirementRow(
                text: "One uppercase letter",
                isMet: validation.requirements.hasUppercase
            )
            RequirementRow(
                text: "One lowercase letter",
                isMet: validation.requirements.hasLowercase
            )
            RequirementRow(
                text: "One number",
                isMet: validation.requirements.hasNumber
            )
            RequirementRow(
                text: "One special character",
                isMet: validation.requirements.hasSpecialChar
            )
        }
    }
}

struct RequirementRow: View {
    let text: String
    let isMet: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isMet ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isMet ? .green : .gray)
            Text(text)
                .font(.caption)
                .foregroundColor(isMet ? .primary : .secondary)
        }
    }
}

// MARK: - Alternative: Using NSPredicate (More Efficient)
extension String {
    func isValidPassword(minLength: Int = 8) -> (isValid: Bool, errors: [String]) {
        var errors: [String] = []
        
        if count < minLength {
            errors.append("Password must be at least \(minLength) characters")
        }
        
        let uppercasePattern = ".*[A-Z]+.*"
        let lowercasePattern = ".*[a-z]+.*"
        let numberPattern = ".*[0-9]+.*"
        let specialCharPattern = ".*[!@#$%^&*(),.?\":{}|<>]+.*"
        
        let uppercasePredicate = NSPredicate(format: "SELF MATCHES %@", uppercasePattern)
        let lowercasePredicate = NSPredicate(format: "SELF MATCHES %@", lowercasePattern)
        let numberPredicate = NSPredicate(format: "SELF MATCHES %@", numberPattern)
        let specialCharPredicate = NSPredicate(format: "SELF MATCHES %@", specialCharPattern)
        
        if !uppercasePredicate.evaluate(with: self) {
            errors.append("Must contain uppercase letter")
        }
        if !lowercasePredicate.evaluate(with: self) {
            errors.append("Must contain lowercase letter")
        }
        if !numberPredicate.evaluate(with: self) {
            errors.append("Must contain number")
        }
        if !specialCharPredicate.evaluate(with: self) {
            errors.append("Must contain special character")
        }
        
        return (errors.isEmpty, errors)
    }
}

