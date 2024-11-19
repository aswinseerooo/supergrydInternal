//
//  Button+Ext.swift
//
//
//  Created by Aswin V Shaji on 05/11/24.
//

import SwiftUI

extension Button where Label == Text {
  init(_ titleKey: LocalizedStringKey, action: @escaping () -> Void) {
    self.init(action: action) {
      Text(titleKey, bundle: .module)
    }
  }
}
