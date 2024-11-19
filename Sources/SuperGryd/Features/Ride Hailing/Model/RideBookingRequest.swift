//
//  RideBookingRequest.swift
//
//
//  Created by Aswin V Shaji on 18/11/24.
//

import Foundation

struct RideBookingRequest: Encodable {
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let email: String
    let startLocation: Location
    let endLocation: Location
    let productId: String
    let fareId: String
    let userId: String
    let price: Double
    
    struct Location: Encodable {
        let lat: Double
        let long: Double
        let address: String
    }
}

