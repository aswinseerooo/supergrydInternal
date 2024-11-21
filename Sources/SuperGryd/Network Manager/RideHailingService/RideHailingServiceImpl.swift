//
//  RideHailingServiceImpl.swift
//  
//
//  Created by Aswin V Shaji on 12/11/24.
//

import Alamofire
import Foundation

class RideHailingServiceImpl {
    static let shared = RideHailingServiceImpl()
    private init() {}
    private var otp: Int? = nil
    // New function to request ride price estimate
    func requestPriceEstimate(
        startLocation: (lat: Double, long: Double),
        endLocation: (lat: Double, long: Double),
        completion: @escaping (Result<RideRequestPriceEstimateResponse, Error>) -> Void
    ) {
        // URL for price estimate
        let url = "\(AppConstants.baseURL)ride-hail/ride-request-price-estimate"
        // Headers
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AppConstants.accessToken)",
            "Content-Type": "application/json"
        ]
        // Request body
        let parameters: [String: Any] = [
            "start_location": [
                "lat": startLocation.lat,
                "long": startLocation.long
            ],
            "end_location": [
                "lat": endLocation.lat,
                "long": endLocation.long
            ]
        ]
        // Make the API request using the generalized APIService
        APIService.shared.request(
            url: url,
            method: .post,
            parameters: parameters,
            headers: headers,
            responseType: RideRequestPriceEstimateResponse.self
        ) { result in
            switch result {
            case .success(let priceEstimateResponse):
                completion(.success(priceEstimateResponse))
            case .failure(let error):
                print("Price Estimate Failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    
    func bookRide(
            firstName: String,
            lastName: String,
            phoneNumber: String,
            email: String,
            startLocation: (lat: Double, long: Double, address: String),
            endLocation: (lat: Double, long: Double, address: String),
            productId: String,
            fareId: String,
            userId: String,
            price: Double,
            completion: @escaping (Result<RideBookingResponse, Error>) -> Void
        ) {
            // URL for booking a ride
            let url = "\(AppConstants.baseURL)ride-hail/ride-booking"
            // Headers
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(AppConstants.accessToken)",
                "Content-Type": "application/json",
                "accept": "*/*"
            ]
                        // Request body
            let parameters: [String: Any] = [
                "first_name": firstName,
                "last_name": lastName,
                "phone_number": phoneNumber,
                "email": email,
                "start_location": [
                    "lat": startLocation.lat,
                    "long": startLocation.long,
                    "address": startLocation.address
                ],
                "end_location": [
                    "lat": endLocation.lat,
                    "long": endLocation.long,
                    "address": endLocation.address
                ],
                "product_id": productId,
                "fare_id": fareId,
                "user_id": userId,
                "price": price
            ]
            // Make the API request using the generalized APIService
            APIService.shared.request(
                url: url,
                method: .post,
                parameters: parameters,
                headers: headers,
                responseType: RideBookingResponse.self
            ) { result in
                switch result {
                case .success(let bookingResponse):
                    completion(.success(bookingResponse))
                case .failure(let error):
                    print("Ride Booking Failed: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    
    func fetchCancelReasons(completion: @escaping (Result<CancelReasonsResponse, Error>) -> Void) {
            // Define the full URL
        let url = "\(AppConstants.cabURL)booking/cancel/reasons/rider"

            // Make the GET request
            APIService.shared.request(
                url: url,
                method: .get,
                responseType: CancelReasonsResponse.self
            ) { result in
                switch result {
                case .success(let reasons):
                    completion(.success(reasons))
                case .failure(let error):
                    print("Failed to Fetch Cancel Reasons: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    
    func cancelRide(
        requestId: Int,
        reasonId: Int,
        reason: String,
        completion: @escaping (Result<RideBookingResponse, Error>) -> Void
    ) {
        // URL for cancelling a ride
        let url = "\(AppConstants.baseURL)ride-hail/ride-cancel"
        
        // Headers
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AppConstants.accessToken)",
            "Content-Type": "application/json",
            "accept": "*/*"
        ]
        
        // Request body
        let parameters: [String: Any] = [
            "request_id": requestId,
            "reason_id": reasonId,
            "reason": reason
        ]
        
        // Make the API request using the generalized APIService
        APIService.shared.request(
            url: url,
            method: .post,
            parameters: parameters,
            headers: headers,
            responseType: RideBookingResponse.self
        ) { result in
            switch result {
            case .success(let cancelResponse):
                completion(.success(cancelResponse))
            case .failure(let error):
                print("Ride Cancellation Failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func trackRide(
        requestId: Int,
        otp: Int? = nil,
        completion: @escaping (Result<RideTrackingResponse, Error>) -> Void
    ) {
        // Base URL
        var urlComponents = URLComponents(string: "\(AppConstants.cabURL)booking/track-ride")!
        // Query parameters
        var queryItems = [URLQueryItem(name: "request_id", value: String(requestId))]
        if let otp = otp {
            queryItems.append(URLQueryItem(name: "otp", value: String(otp)))
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
       
        // Make the API request
        APIService.shared.request(
            url: url.absoluteString,
            method: .get,
            responseType: RideTrackingResponse.self
        ) { result in
            switch result {
            case .success(let trackingResponse):
                completion(.success(trackingResponse))
                // Check the ride status and call recursively if needed
                if let otpValue = trackingResponse.otp, self.otp == nil {
                    self.otp = otpValue
                }
                if trackingResponse.rideStatus == 6 {
                    print("Ride Completed: \(trackingResponse)")
                } else if trackingResponse.rideStatus == 3 {
                    // Include OTP in the next call
                    DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                        self.trackRide(requestId: requestId, otp: self.otp, completion: completion)
                    }
                } else {
                    // Continue polling without OTP
                    DispatchQueue.global().asyncAfter(deadline: .now() + 2) { // Adjust interval as needed
                        self.trackRide(requestId: requestId, completion: completion)
                    }
                }
            case .failure(let error):
                print("Tracking Ride Failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func requestNearbyPlaces(
            latitude: Double,
            longitude: Double,
            radius: Double,
            apiKey: String,
            completion: @escaping (Result<GooglePlacesNearbyResponse, Error>) -> Void
        ) {
            // URL for Google Places Nearby Search API
            let url = AppConstants.placeURL
            
            // Headers
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "X-Goog-Api-Key": apiKey,
                "X-Goog-FieldMask": "*"
            ]
            
            // Request body parameters
            let parameters: [String: Any] = [
                "maxResultCount": 1,
                "locationRestriction": [
                    "circle": [
                        "center": [
                            "latitude": latitude,
                            "longitude": longitude
                        ],
                        "radius": radius
                    ]
                ]
            ]
            
            APIService.shared.request(
                url: url,
                method: .post,
                parameters: parameters,
                headers: headers,
                responseType: GooglePlacesNearbyResponse.self
            ) { result in
                switch result {
                case .success(let GooglePlacesNearbyResponse):
                    completion(.success(GooglePlacesNearbyResponse))
                case .failure(let error):
                    print("Search Nearby Failed: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
}
