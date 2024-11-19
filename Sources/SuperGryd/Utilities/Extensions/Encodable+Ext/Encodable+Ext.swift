//
//  Encodable+Ext.swift
//
//
//  Created by Aswin V Shaji on 18/11/24.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    }
}
