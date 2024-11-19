//
//  AuthenticationResponseModel.swift
//
//
//  Created by Aswin V Shaji on 19/10/24.
//

import Foundation

/// Response model for authentication
struct AuthenticationResponse: Codable {
    let status: Int
    let message: String
    let data: AuthenticationData?
}

struct AuthenticationData: Codable {
    let accessToken: String
    let refreshToken: String
    let accessTokenExpiry: String
    let refreshTokenExpiry: String
    let themes: [Theme]
}

struct Theme: Codable {
    let primaryColor: String
    let secondaryColor: String
    let accentColor: String
    let font: String
    let id: String

    // Map JSON keys to Swift property names
    private enum CodingKeys: String, CodingKey {
        case primaryColor = "primary_color"
        case secondaryColor = "secondary_color"
        case accentColor = "accent_color"
        case font
        case id = "_id"
    }
}
