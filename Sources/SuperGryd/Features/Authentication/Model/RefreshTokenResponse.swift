//
//  RefreshTokenResponse.swift
//
//
//  Created by Aswin V Shaji on 18/11/24.
//

import Foundation

// MARK: - RefreshTokenResponse
struct RefreshTokenResponse: Codable {
    let status: Int?
    let message: String?
    let data: RefreshTokenData?
}

// MARK: - DataClass
struct RefreshTokenData: Codable {
    let accessToken, refreshToken: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
