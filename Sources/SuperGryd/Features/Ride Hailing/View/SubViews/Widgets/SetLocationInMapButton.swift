//
//  SetLocationInMapButton.swift
//  
//
//  Created by Aswin V Shaji on 26/10/24.
//

import SwiftUI

struct SetLocationInMapButton: View {
    var body: some View {
        HStack {
            Image("locationIcon",bundle: Bundle.module)
                .padding(.leading,15)
                .padding(.trailing, 5)
            Text("set_location_on_map")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
#Preview {
    SetLocationInMapButton()
}
