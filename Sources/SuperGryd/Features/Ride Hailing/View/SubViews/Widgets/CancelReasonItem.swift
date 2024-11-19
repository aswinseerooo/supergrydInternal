//
//  CancelReasonItem.swift
//
//
//  Created by Aswin V Shaji on 29/10/24.
//

import SwiftUI

struct CancelReasonItem: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        HStack {
            if isSelected {
                Circle()
                    .foregroundStyle(Color(hex: "#663A80"))
                    .frame(height: 25)
            } else {
                Circle()
                    .stroke(Color(hex: "#6C7B88"), lineWidth: 1.5)
                    .frame(height: 25)
            }
            Text(title)
                .font(.callout)
                .fontWeight(.regular)
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    CancelReasonItem(title: "Title", isSelected: true)
}
