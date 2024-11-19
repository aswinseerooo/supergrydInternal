//
//  CancelReasonsResponse.swift
//
//
//  Created by Aswin V Shaji on 19/11/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let cancelReasonsResponse = try? JSONDecoder().decode(CancelReasonsResponse.self, from: jsonData)

import Foundation

// MARK: - CancelReasonsResponse
struct CancelReasonsResponse: Codable {
    let data: [CancelReasonData]?
}

// MARK: - Datum
struct CancelReasonData: Codable {
    let reasonID: Int?
    let reason: String?

    enum CodingKeys: String, CodingKey {
        case reasonID = "reason_id"
        case reason
    }
}
