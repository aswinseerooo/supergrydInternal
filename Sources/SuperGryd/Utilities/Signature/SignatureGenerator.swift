//
//  SignatureGenerator.swift
//
//
//  Created by Aswin V Shaji on 19/10/24.
//

import Foundation
import CommonCrypto

/// Utility to generate HMAC SHA-256 signature
import Foundation
import CommonCrypto

struct SignatureHelper {
    static func generateSignature(apiSecret: String, clientId: String) -> (apiKey: String, signature: String) {
        let encodeSecret = apiSecret.data(using: .utf8)!
        
        // Calculate the `utz` value based on the current time
        let utz = Int(Date().timeIntervalSince1970) / 300
        let mainKey = "\(utz):\(apiSecret)"
        let encodedMainKey = mainKey.data(using: .utf8)!
        
        // Create HMAC SHA-256
        var hmac = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        encodedMainKey.withUnsafeBytes { mainKeyBytes in
            encodeSecret.withUnsafeBytes { secretBytes in
                CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), mainKeyBytes.baseAddress, encodedMainKey.count, secretBytes.baseAddress, encodeSecret.count, &hmac)
            }
        }
        
        // Convert HMAC result to base64-encoded signature
        let signatureData = Data(hmac)
        let finalSignature = signatureData.base64EncodedString()
        
        return (apiKey: clientId, signature: finalSignature)
    }
}
