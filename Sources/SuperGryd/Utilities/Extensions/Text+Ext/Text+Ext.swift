//
//  Text+Ext.swift
//  
//
//  Created by Aswin V Shaji on 05/11/24.
//

import SwiftUI

extension Text {
  init(_ key: LocalizedStringKey, comment: String = "") {
    self.init(key, bundle: .module)
  }
}
