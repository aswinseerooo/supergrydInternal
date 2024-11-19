//
//  RideHailingServiceImpl.swift
//  
//
//  Created by Aswin V Shaji on 12/11/24.
//

import Alamofire

class RideHailingServiceImpl {
    static let shared = RideHailingServiceImpl()
    private init() {}
    
    // New function to request ride price estimate
    func requestPriceEstimate(
        startLocation: (lat: Double, long: Double),
        endLocation: (lat: Double, long: Double),
        completion: @escaping (Result<RideRequestPriceEstimateResponse, Error>) -> Void
    ) {
        // URL for price estimate
        let url = "\(AppConstants.baseURL)ride-hail/ride-request-price-estimate"
        print("URL =", url)
        // Headers
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(AppConstants.accessToken)",
            "Content-Type": "application/json"
        ]
        print("headers =", headers)
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
        print("parameters =", parameters)
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
                print("Price Estimate Successful: \(priceEstimateResponse)")
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
