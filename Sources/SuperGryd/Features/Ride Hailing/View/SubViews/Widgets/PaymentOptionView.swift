//
//  PaymentOptionView.swift
//
//
//  Created by Aswin V Shaji on 29/10/24.
//

import SwiftUI

struct PaymentOptionView: View {
    let iconName: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Image(iconName, bundle: Bundle.module)
                .padding(10)
                .overlay(
                    Circle()
                        .stroke(Color(hex: "#663A80").opacity(0.3), lineWidth: 1.5)
                )
            Text(title)
            Spacer()
            
            if isSelected {
                Circle()
                    .foregroundStyle(Color(hex: "#663A80"))
                    .frame(height: 25)
            } else {
                Circle()
                    .stroke(Color(hex: "#6C7B88"), lineWidth: 1.5)
                    .frame(height: 23.5)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    PaymentOptionView(iconName: "cash", title: "Title", isSelected: true)
}
