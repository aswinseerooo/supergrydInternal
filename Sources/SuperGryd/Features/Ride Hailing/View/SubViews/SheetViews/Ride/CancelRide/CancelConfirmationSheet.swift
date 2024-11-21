//
//  CancelConfirmationSheet.swift
//
//
//  Created by Aswin V Shaji on 31/10/24.
//

import SwiftUI

struct CancelConfirmationSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: RideViewModel
    var body: some View {
        VStack() {
            // Display total distance covered
            Spacer().frame(height: 20)
            Text("do_you_want_to_cancel_the_ride")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.top,20)
                .padding(.horizontal,20)
            Text(viewModel.isFindingRide ? "you_wont_be_charged_a_cancellation_fee" : "you_may_be_charged_a_cancellation_fee")
                .font(.subheadline)
                .padding(.top, 5)
            Divider()
                .padding(.horizontal, 20)
                .padding(.vertical,20)
            HStack{
                LargeButton(
                    title: viewModel.isFindingRide ? "no".localized() : "go_back".localized(),
                    backgroundColor: Color.white,
                    foregroundColor: Color(hex: "#663A80"),
                    buttonHorizontalMargins: 5
                ) {
                    viewModel.isCancelClicked = false
                }
                LargeButton(
                    title: viewModel.isFindingRide ? "yes_cancel".localized() : "cancel_trip".localized(),
                    backgroundColor: Color(hex: "#663A80"),
                    foregroundColor: Color.white,
                    buttonHorizontalMargins: 5
                ) {
                    viewModel.isCancelClicked = false
                    viewModel.isShowingCancelReasons = true
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom)
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding(.bottom, 20)
    }
}

#Preview {
    CancelConfirmationSheet(viewModel: RideViewModel())
}
