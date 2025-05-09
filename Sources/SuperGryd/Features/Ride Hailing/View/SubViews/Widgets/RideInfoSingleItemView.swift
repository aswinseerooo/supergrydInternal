//
//  RideInfoItemView.swift
//
//
//  Created by Aswin V Shaji on 29/10/24.
//

import SwiftUI

struct RideInfoSingleItemView: View {
    let imageName: String
    let text: Text

    var body: some View {
        HStack(spacing: 4) {
            Image(imageName, bundle: Bundle.module)
            text
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    RideInfoSingleItemView(imageName: "", text: Text(""))
}
