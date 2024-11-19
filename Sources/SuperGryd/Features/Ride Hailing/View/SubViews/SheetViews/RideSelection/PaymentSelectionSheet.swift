//
//  PaymentSelectionSheet.swift
//
//
//  Created by Aswin V Shaji on 29/10/24.
//

import SwiftUI

struct PaymentSelectionSheet: View {
    @ObservedObject var viewModel: RideSelectionViewModel

    var body: some View {
        VStack(alignment: .leading) {
            // Display total distance covered
            Spacer().frame(height: 15)
            Text("payment_methods")
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .padding()
            PaymentOptionView(
                iconName: "cash",
                title: "cash".localized(),
                isSelected: viewModel.paymentOption == "cash".localized()
            )
            .onTapGesture {
                viewModel.paymentOption = "cash".localized()
                viewModel.paymentIcon = "cash"
            }
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color(hex: "#F1F5F9"))
                .padding(.horizontal, 20)
            PaymentOptionView(
                iconName: "onlinePayment",
                title: "online".localized(),
                isSelected: viewModel.paymentOption == "online".localized()
            )
            .onTapGesture {
                viewModel.paymentOption = "online".localized()
                viewModel.paymentIcon = "onlinePayment"
            }
            
            LargeButton(
                title: "submit".localized(),
                backgroundColor: Color.white,
                foregroundColor: Color(hex: "#663A80")
            ) {
                viewModel.isPaymentSelectionSheetShowing = false
            }
            .padding(.bottom)
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding(.bottom, 20)
    }
}

#Preview {
    PaymentSelectionSheet(viewModel: RideSelectionViewModel())
}
