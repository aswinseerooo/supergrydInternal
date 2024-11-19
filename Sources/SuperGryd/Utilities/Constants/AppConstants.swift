//
//  AppConstants.swift
//
//
//  Created by Aswin V Shaji on 19/10/24.
//

import Foundation

final class AppConstants {
    static var isAuthenticated = false
    static var key: String = ""
    static var signature: String = ""
    static var accessToken: String = ""
    static var refreshToken: String = ""
    static var userId: String = ""
    static let baseURL: String = "http://52.66.208.144/api/v1/"
    static let cabURL: String = "https://supergrydapi.ritikasingh.site/uber/v1/"
    static let placeURL: String = "https://places.googleapis.com/v1/places:searchNearby"
}
