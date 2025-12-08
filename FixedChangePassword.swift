import Foundation

// MARK: - Response Models
struct ChangePasswordResponse: Codable {
    let message: String?
    let error: String?
    let details: [String: [String]]?
    let field_count: Int?
    
    var isSuccess: Bool {
        message != nil
    }
}

// MARK: - Fixed Change Password Function
extension AuthViewModel {
    
    struct PasswordCredential: Codable {
        let current_password: String
        let new_password: String
        let confirm_password: String
    }
    
    @Published var changePasswordResult: ChangePasswordResponse?
    
    func changePassword(oldPassword: String, newPassword: String) async throws {
        guard !isLoading else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        guard await checkInternetConnection() else {
            throw NetworkError.noInternet.toNSError()
        }
        
        errorMessage = nil
        
        guard let url = URL(string: "\(baseURL)/accounts/change-password/") else {
            throw NetworkError.unknown("Invalid URL").toNSError()
        }
        
        let credentials = PasswordCredential(
            current_password: oldPassword,
            new_password: newPassword,
            confirm_password: newPassword
        )
        
        do {
            let encodedData = try JSONEncoder().encode(credentials)
            
            // ✅ FIX: auth should be TRUE (requires JWT token)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Add authentication token
            if let token = UserDefaults.standard.string(forKey: "accessToken") {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            request.httpBody = encodedData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown("Invalid Response").toNSError()
            }
            
            // Print response for debugging
            if let responseString = String(data: data, encoding: .utf8) {
                print("📋 Change Password Response: \(responseString)")
            }
            
            // Decode response (works for both success and error)
            let changeResponse = try JSONDecoder().decode(ChangePasswordResponse.self, from: data)
            changePasswordResult = changeResponse
            
            // Handle based on status code
            if httpResponse.statusCode == 200 {
                // Success
                print("✅ Password changed successfully: \(changeResponse.message ?? "")")
                // Optionally clear tokens to force re-login
                // UserDefaults.standard.removeObject(forKey: "accessToken")
                // UserDefaults.standard.removeObject(forKey: "refreshToken")
            } else {
                // Error response
                if let errorMsg = changeResponse.error {
                    errorMessage = errorMsg
                    print("❌ Password change error: \(errorMsg)")
                    
                    // Throw validation error
                    throw AuthError.validationError(
                        message: errorMsg,
                        details: changeResponse.details
                    )
                } else {
                    // Unknown error
                    if let networkError = NetworkError.from(httpStatusCode: httpResponse.statusCode) {
                        throw networkError.toNSError()
                    } else {
                        throw NetworkError.unknown("Server returned status code: \(httpResponse.statusCode)").toNSError()
                    }
                }
            }
            
        } catch let authError as AuthError {
            // Handle AuthError (including validation errors)
            errorMessage = authError.errorDescription
            print("❌ Auth Error: \(authError.errorDescription ?? "Unknown")")
            throw authError
        } catch let decodingError as DecodingError {
            print("❌ Decoding Error: \(decodingError)")
            errorMessage = "Failed to decode server response"
            throw NetworkError.unknown("Failed to decode response").toNSError()
        } catch {
            if let urlError = error as? URLError {
                throw NetworkError.from(urlError).toNSError()
            }
            print("❌ Error: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
            throw error
        }
    }
}


