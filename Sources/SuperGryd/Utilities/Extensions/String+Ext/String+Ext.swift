//
//  String+Ext.swift
//
//
//  Created by Aswin V Shaji on 05/11/24.
//

import Foundation

extension String {
    func localized(bundle: Bundle = .module) -> String {
        NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
