//
//  RideTrackingResponse.swift
//
//
//  Created by Aswin V Shaji on 20/11/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let rideTrackingResponse = try? JSONDecoder().decode(RideTrackingResponse.self, from: jsonData)

import Foundation

// MARK: - RideTrackingResponse
struct RideTrackingResponse: Codable {
    let requestID, status, message, code: String?
    let rideStatus: Int?
    let driverLat, driverLng: String?
    let driverDetails: DriverDetails?
    let vehicle: Vehicle?
    let otp: Int?

    enum CodingKeys: String, CodingKey {
        case requestID = "request_id"
        case status, message, code
        case rideStatus = "ride_status"
        case driverLat = "driver_lat"
        case driverLng = "driver_lng"
        case driverDetails = "driver_details"
        case vehicle, otp
    }
}

// MARK: - DriverDetails
struct DriverDetails: Codable {
    let phoneNumber: String?
    let rating: Double?
    let pictureURL: String?
    let name, smsNumber: String?

    enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone_number"
        case rating
        case pictureURL = "picture_url"
        case name
        case smsNumber = "sms_number"
    }
}

// MARK: - Vehicle
struct Vehicle: Codable {
    let make: String?
    let pictureURL: String?
    let model, licensePlate: String?

    enum CodingKeys: String, CodingKey {
        case make
        case pictureURL = "picture_url"
        case model
        case licensePlate = "license_plate"
    }
}
