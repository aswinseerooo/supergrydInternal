//
//  AuthenticationViewModel.swift
//
//
//  Created by Aswin V Shaji on 19/10/24.
//

import SwiftUI

class Authentication: ObservableObject {
    
    public static let shared = Authentication()
    @Published var errorMessage: String?
    @Published var isLoading = false  // Loading state
     
    private init() { }
   
    
    // Function to authenticate
    func authenticate(clientId: String, clientSecret: String) {
        self.isLoading = true  // Set loading state to true when the authentication starts
        AuthenticationServiceImpl.shared.authenticate(clientId: clientId, clientSecret: clientSecret) { [weak self] result in
            DispatchQueue.main.async {  // Ensure state updates happen on the main thread
                self?.isLoading = false
                switch result {
                case .success(let authResponse):
                    // Handle success (Store tokens, navigate, etc.)
                    print("Authentication successful with token: \(String(describing: authResponse.data?.accessToken))")
                    AppConstants.isAuthenticated = true
                    AppConstants.accessToken = authResponse.data?.accessToken ?? ""
                    AppConstants.refreshToken = authResponse.data?.refreshToken ?? ""
                    self?.createUser()
                    self?.errorMessage = nil
                case .failure(let error):
                    // Handle failure (show error message)
                    print("Authentication failed: \(error)")
                    AppConstants.isAuthenticated = false
                    self?.errorMessage = "Authentication failed. Please try again."
                }
            }
        }
    }
    
    func createUser() {
        guard !AppConstants.accessToken.isEmpty else {
            print("Access token is missing. Cannot create user.")
            self.errorMessage = "Access token is missing. Cannot create user."
            return
        }
        
        AuthenticationServiceImpl.shared.createUser(
            phoneNumber: "9645989889",
            phoneCode: "+91",
            name: "Seeroo"
        ) { [weak self] result in
            DispatchQueue.main.async {  // Ensure state updates happen on the main thread
                switch result {
                case .success(let response):
                    print("User Created: \(response)")
                    AppConstants.userId = response.data?.id ?? ""
                    self?.errorMessage = nil
                case .failure(let error):
                    print("Failed to Create User: \(error.localizedDescription)")
                    self?.errorMessage = "Failed to create user. Please try again."
                }
            }
        }
    }
}

