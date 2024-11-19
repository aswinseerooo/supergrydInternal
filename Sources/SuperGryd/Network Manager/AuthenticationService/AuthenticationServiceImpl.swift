//
//  AuthenticationServiceImpl.swift
//
//
//  Created by Aswin V Shaji on 19/10/24.
//

import Alamofire

class AuthenticationServiceImpl {
    static let shared = AuthenticationServiceImpl()
    private init() {}
    
    // Function to handle authentication
    func authenticate(clientId: String, clientSecret: String, completion: @escaping (Result<AuthenticationResponse, Error>) -> Void) {
        // Generate signature and API key using SignatureHelper
        let (apiKey, signature) = SignatureHelper.generateSignature(apiSecret: clientSecret, clientId: clientId)
        
        // Set app constants
        AppConstants.key = apiKey
        AppConstants.signature = signature
        
        // Print the generated API key and signature for debugging
        print("Generated API Key: \(AppConstants.key)")
        print("Generated Signature: \(AppConstants.signature)")
        
        // Headers
        let headers: HTTPHeaders = [
            "x-api-signature": signature,
            "x-api-key": apiKey,
            "Content-Type": "application/json"
        ]
        
        // URL for authentication
        let url = "\(AppConstants.baseURL)auth/auth-verificationV2"
        
        // Print URL for debugging
        print("Request URL: \(url)")
        
        // Make the API request using the generalized APIService
        APIService.shared.request(url: url, method: .post, headers: headers, responseType: AuthenticationResponse.self) { result in
            switch result {
            case .success(let authResponse):
                print("Authentication Successful: \(authResponse)")
                completion(.success(authResponse))
            case .failure(let error):
                print("Authentication Failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func createUser(phoneNumber: String, phoneCode: String, name: String, completion: @escaping (Result<CreateUserResponse, Error>) -> Void) {
           // Headers
           let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AppConstants.accessToken)",
               "Content-Type": "application/json",
               "accept": "*/*"
           ]
           
           // Body
           let parameters: [String: Any] = [
               "phone_number": phoneNumber,
               "phone_code": phoneCode,
               "name": name
           ]
           
           // URL for creating users
           let url = "\(AppConstants.baseURL)sdk/create-users"
           print("Request URL: \(url)")
           
           // Make the API request using the generalized APIService
           APIService.shared.request(url: url, method: .post, parameters: parameters, headers: headers, responseType: CreateUserResponse.self) { result in
               switch result {
               case .success(let createUserResponse):
                   print("User Creation Success: \(createUserResponse.message ?? "")")
                   completion(.success(createUserResponse))
               case .failure(let error):
                   print("User Creation Failed: \(error.localizedDescription)")
                   completion(.failure(error))
               }
           }
       }
}
