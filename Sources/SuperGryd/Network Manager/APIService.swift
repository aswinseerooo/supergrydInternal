//
//  NetworkManager.swift
//
//
//  Created by Aswin V Shaji on 19/10/24.
//

import Alamofire

class APIService {
    // Singleton instance for reusability
    static let shared = APIService()
    private init() {}

    private var isRefreshingToken = false
    private var requestQueue: [(RetryRequest)] = []

    typealias RetryRequest = () -> Void

    /// Function to make a general API request
    func request<T: Decodable>(
        url: String,
        method: HTTPMethod = .get,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        var requestHeaders = headers ?? [:]
            
        // Check and update Authorization header only if it exists
            if let existingAuthorization = requestHeaders["Authorization"],
               existingAuthorization != "Bearer \(AppConstants.accessToken)" {
                requestHeaders["Authorization"] = "Bearer \(AppConstants.accessToken)"
            }
        
        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: requestHeaders)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: responseType) { response in
                switch response.result {
                case .success(let result):
                    completion(.success(result))
                case .failure(let error):
                    if let statusCode = response.response?.statusCode, statusCode == 401 || statusCode == 403 {
                        // Handle token refresh and retry the request
                        self.enqueueRetry {
                            self.request(
                                url: url,
                                method: method,
                                parameters: parameters,
                                headers: headers,
                                responseType: responseType,
                                completion: completion
                            )
                        }
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }

    /// Enqueue a retryable request
    private func enqueueRetry(_ retryRequest: @escaping RetryRequest) {
        requestQueue.append(retryRequest)
        if !isRefreshingToken {
            refreshToken { [weak self] success in
                guard let self = self else { return }
                self.isRefreshingToken = false
                if success {
                    // Retry all queued requests
                    self.requestQueue.forEach { $0() }
                } else {
                    print("Failed to refresh token. Requests will not be retried.")
                }
                self.requestQueue.removeAll()
            }
        }
    }

    /// Function to refresh the token
    private func refreshToken(completion: @escaping (Bool) -> Void) {
        isRefreshingToken = true

        let url = "\(AppConstants.baseURL)auth/auth-refresh"
        let parameters: [String: Any] = [
            "refresh_token": AppConstants.refreshToken
        ]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: RefreshTokenResponse.self) { response in
                switch response.result {
                case .success(let tokenResponse):
                    // Update tokens
                    AppConstants.accessToken = tokenResponse.data?.accessToken ?? ""
                    AppConstants.refreshToken = tokenResponse.data?.refreshToken ?? ""
                    completion(true)
                case .failure(let error):
                    print("Failed to refresh token: \(error.localizedDescription)")
                    completion(false)
                }
            }
    }
}

