//
//  CreateUserResponse.swift
//
//
//  Created by Aswin V Shaji on 18/11/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let createUserResponse = try? JSONDecoder().decode(CreateUserResponse.self, from: jsonData)

import Foundation

// MARK: - CreateUserResponse
struct CreateUserResponse: Codable {
    let status: Int?
    let message: String?
    let data: UserData?
}

// MARK: - DataClass
struct UserData: Codable {
    let id, phoneNumber: String?
    let v: Int?
    let createdAt, hostID, name, phoneCode: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case phoneNumber = "phone_number"
        case v = "__v"
        case createdAt
        case hostID = "host_id"
        case name
        case phoneCode = "phone_code"
        case updatedAt
    }
}
