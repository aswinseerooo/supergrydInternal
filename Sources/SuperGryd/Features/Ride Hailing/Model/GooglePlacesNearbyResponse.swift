//
//  GooglePlacesNearbyResponse.swift
//
//
//  Created by Aswin V Shaji on 14/11/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let googlePlacesNearbyResponse = try? JSONDecoder().decode(GooglePlacesNearbyResponse.self, from: jsonData)

import Foundation

// MARK: - GooglePlacesNearbyResponse
struct GooglePlacesNearbyResponse: Codable {
    let places: [Place]?
}

// MARK: - Place
struct Place: Codable {
    let id: String?
//    let name, id: String?
//    let types: [String]?
//    let nationalPhoneNumber, internationalPhoneNumber, formattedAddress: String?
//    let addressComponents: [AddressComponent]?
//    let plusCode: PlusCode?
    let location: Location?
//    let viewport: Viewport?
//    let rating: Double?
//    let googleMapsURI, websiteURI: String?
//    let regularOpeningHours: OpeningHours?
//    let utcOffsetMinutes: Int?
//    let adrFormatAddress, businessStatus: String?
//    let userRatingCount: Int?
//    let iconMaskBaseURI: String?
//    let iconBackgroundColor: String?
    let displayName: DisplayName?
//    let currentOpeningHours: OpeningHours?
    let shortFormattedAddress: String?
//    let reviews: [Review]?
//    let photos: [Photo]?
//    let addressDescriptor: AddressDescriptor?
//    let googleMapsLinks: GoogleMapsLinks?

    enum CodingKeys: String, CodingKey {
        case id
        case location
        case displayName
        case shortFormattedAddress
//        case name, id, types, nationalPhoneNumber, internationalPhoneNumber, formattedAddress, addressComponents, plusCode, location, viewport, rating
//        case googleMapsURI = "googleMapsUri"
//        case websiteURI = "websiteUri"
//        case regularOpeningHours, utcOffsetMinutes, adrFormatAddress, businessStatus, userRatingCount
//        case iconMaskBaseURI = "iconMaskBaseUri"
//        case iconBackgroundColor, displayName, currentOpeningHours, shortFormattedAddress, reviews, photos, addressDescriptor, googleMapsLinks
    }
}

// MARK: - AddressComponent
struct AddressComponent: Codable {
    let longText, shortText: String?
    let types: [String]?
    let languageCode: String?
}

// MARK: - AddressDescriptor
struct AddressDescriptor: Codable {
    let landmarks: [Landmark]?
    let areas: [Area]?
}

// MARK: - Area
struct Area: Codable {
    let name, placeID: String?
    let displayName: DisplayName?
    let containment: String?

    enum CodingKeys: String, CodingKey {
        case name
        case placeID = "placeId"
        case displayName, containment
    }
}

// MARK: - DisplayName
struct DisplayName: Codable {
    let text: String?
    let languageCode: LanguageCode?
}

enum LanguageCode: String, Codable {
    case en = "en"
}

// MARK: - Landmark
struct Landmark: Codable {
    let name, placeID: String?
    let displayName: DisplayName?
    let types: [String]?
    let spatialRelationship: String?
    let straightLineDistanceMeters, travelDistanceMeters: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case placeID = "placeId"
        case displayName, types, spatialRelationship, straightLineDistanceMeters, travelDistanceMeters
    }
}

// MARK: - OpeningHours
struct OpeningHours: Codable {
    let openNow: Bool?
    let periods: [Period]?
    let weekdayDescriptions: [String]?
    let nextCloseTime: Date?
}

// MARK: - Period
struct Period: Codable {
    let periodOpen, close: Close?

    enum CodingKeys: String, CodingKey {
        case periodOpen = "open"
        case close
    }
}

// MARK: - Close
struct Close: Codable {
    let day, hour, minute: Int?
    let date: DateClass?
}

// MARK: - DateClass
struct DateClass: Codable {
    let year, month, day: Int?
}

// MARK: - GoogleMapsLinks
struct GoogleMapsLinks: Codable {
    let directionsURI, placeURI, writeAReviewURI, reviewsURI: String?
    let photosURI: String?

    enum CodingKeys: String, CodingKey {
        case directionsURI = "directionsUri"
        case placeURI = "placeUri"
        case writeAReviewURI = "writeAReviewUri"
        case reviewsURI = "reviewsUri"
        case photosURI = "photosUri"
    }
}

// MARK: - Location
struct Location: Codable {
    let latitude, longitude: Double?
}

// MARK: - Photo
struct Photo: Codable {
    let name: String?
    let widthPx, heightPx: Int?
    let authorAttributions: [AuthorAttribution]?
    let flagContentURI, googleMapsURI: String?

    enum CodingKeys: String, CodingKey {
        case name, widthPx, heightPx, authorAttributions
        case flagContentURI = "flagContentUri"
        case googleMapsURI = "googleMapsUri"
    }
}

// MARK: - AuthorAttribution
struct AuthorAttribution: Codable {
    let displayName: String?
    let uri, photoURI: String?

    enum CodingKeys: String, CodingKey {
        case displayName, uri
        case photoURI = "photoUri"
    }
}

// MARK: - PlusCode
struct PlusCode: Codable {
    let globalCode, compoundCode: String?
}

// MARK: - Review
struct Review: Codable {
    let name, relativePublishTimeDescription: String?
    let rating: Int?
    let text, originalText: DisplayName?
    let authorAttribution: AuthorAttribution?
    let publishTime: String?
    let flagContentURI, googleMapsURI: String?

    enum CodingKeys: String, CodingKey {
        case name, relativePublishTimeDescription, rating, text, originalText, authorAttribution, publishTime
        case flagContentURI = "flagContentUri"
        case googleMapsURI = "googleMapsUri"
    }
}

// MARK: - Viewport
struct Viewport: Codable {
    let low, high: Location?
}
