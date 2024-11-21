//
//  FindingRideSheet.swift
//
//
//  Created by Aswin V Shaji on 29/10/24.
//

import SwiftUI

struct FindingRideSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: RideViewModel
    @ObservedObject var locationViewModel: LocationSelectingViewModel
    var body: some View {
        VStack() {
            // Display total distance covered
            Spacer().frame(height: 20)
            Text("finding_your_ride")
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
            LoadingProgressBar()
                .frame(maxWidth: .infinity)
                .padding()
            Image("findingRide", bundle: Bundle.module)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color(hex: "#F1F5F9"))
                .padding(.horizontal, 20)
            HStack(alignment: .top) {
                Image("pickup", bundle: Bundle.module)
                    .padding(.horizontal)
                VStack(alignment: .leading){
                    Text("pick_up")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(locationViewModel.fromLocation)
                        .font(.caption)
                        .fontWeight( .semibold)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity,alignment: .leading)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            HStack(alignment: .top) {
                Image("dropoff", bundle: Bundle.module)
                    .padding(.horizontal)
                VStack(alignment: .leading){
                    Text("drop_off")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(locationViewModel.toLocation)
                        .font(.caption)
                        .fontWeight( .semibold)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity,alignment: .leading)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            HStack(alignment: .top) {
                Image("dollarCircle", bundle: Bundle.module)
                    .padding(.horizontal)
                VStack(alignment: .leading){
                    Text("\(locationViewModel.selectedRide?.estimation?.estimate ?? 0, specifier: "%.2f") \(locationViewModel.selectedRide?.estimation?.currencyCode ?? "")")
                        .font(.caption)
                        .fontWeight( .semibold)
                    Text(locationViewModel.selectedPaymentMethod ?? "")
                        .font(.caption)
                        .foregroundStyle(Color(hex: "#1B4C31"))
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            LargeButton(
                title: "cancel".localized(),
                backgroundColor: Color.white,
                foregroundColor: Color(hex: "#663A80")
            ) {
                viewModel.isCancelClicked = true
            }
            .padding(.bottom)
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding(.bottom, 20)
    }
}

#Preview {
    FindingRideSheet(viewModel: RideViewModel(), locationViewModel: LocationSelectingViewModel())
}

