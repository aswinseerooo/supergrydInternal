//
//  RideNotFoundSheet.swift
//
//
//  Created by Aswin V Shaji on 12/11/24.
//

import SwiftUI

struct RideNotFoundSheet: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack() {
            // Display total distance covered
            Spacer().frame(height: 20)
            Image("rideNotFound", bundle: Bundle.module)
            Text("ride_not_found")
                .font(.headline)
            Text("please_try_again_in_a_few_minutes")
                .font(.subheadline)
                .fontWeight(.light)
            LargeButton(
                title: "try_again".localized(),
                backgroundColor: Color.white,
                foregroundColor: Color(hex: "#663A80")
            ) {
                
            }
            .padding(.bottom)
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding(.bottom, 20)
    }
}

#Preview {
    RideNotFoundSheet()
}
