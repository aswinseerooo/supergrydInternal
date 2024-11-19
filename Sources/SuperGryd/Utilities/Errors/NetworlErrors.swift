//
//  NetworkError.swift
//  
//
//  Created by Aswin V Shaji on 19/10/24.
//

import Foundation

enum NetworkError: Error {
    case noData
    case decodingError
    case serverError(String)
    case unauthorized
}
