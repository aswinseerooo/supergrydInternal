//
//  RideDetailsExpandedSheet.swift
//
//
//  Created by Aswin V Shaji on 31/10/24.
//

import SwiftUI

struct RideDetailsExpandedSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: RideViewModel
    @ObservedObject var locationViewModel: LocationSelectingViewModel
    private let maxRating = 5
    private let unselectedImage = Image("ratingUnselected", bundle: Bundle.module)
    private let selectedImage = Image("ratingSelected", bundle: Bundle.module)

    
    var body: some View {
        VStack{
            Rectangle()
                .frame(width: 50,height: 5)
                .foregroundStyle(Color(hex: "#F1F5F9"))
                .padding()
            VStack(alignment: .leading) {
                // Display total distance covered
                
                Text("ride_details")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)
                
                HStack() {
                    AsyncImage(url: URL(string: viewModel.rideTrackingResponse?.driverDetails?.pictureURL ?? "")) { image in
                        image
                            .resizable() // Ensure the image is resizable
                            .scaledToFit() // Scale the image to fit within the frame
                    } placeholder: {
                        ProgressView() // Optional placeholder while the image is loading
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    VStack(alignment: .leading){
                        Text(viewModel.rideTrackingResponse?.driverDetails?.name ?? "")
                            .font(.headline)
                            .lineLimit(1)
                            .padding(.bottom,1)
                        Text("experience".localized() + ": " + "1 yr")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .padding(.bottom,2)
                        Text("total_rides".localized() + ": " + "1000")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                        HStack(spacing: 8) {
                            ForEach(1...maxRating, id: \.self) { starIndex in
                                (starIndex <= Int(viewModel.rideTrackingResponse?.driverDetails?.rating ?? 0) ? selectedImage : unselectedImage)
                                    .resizable()
                                    .frame(width: 10, height: 10)
                            }
                            Text("\(viewModel.rideTrackingResponse?.driverDetails?.rating ?? 0, specifier: "%.1f")")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal,8)
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal,20)
                Divider()
                    .padding(.horizontal, 20)
                    .padding(.bottom,8)
                RideInfoItemView(
                    distance: Text("\(locationViewModel.selectedRide?.estimation?.distance ?? 0.0, specifier: "%.2f")"),
                    time: Text("\((locationViewModel.selectedRide?.estimation?.duration ?? 0) / 60) min"),
                    price: Text("\(locationViewModel.selectedRide?.estimation?.estimate ?? 0, specifier: "%.2f")"))
                    .padding(.horizontal, 40)
                Divider()
                    .padding(.horizontal, 20)
                    .padding(.top,8)
                Divider()
                    .padding(.horizontal, 20)
                PickupDropoffStepperView(fromLocation: .constant(locationViewModel.fromLocation), toLocation: .constant(locationViewModel.toLocation))
                Divider()
                    .padding(.horizontal, 20)
                    .padding(.bottom,8)
                HStack{
                    VStack(alignment: .leading){
                        Text("payment_method")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        Text("total_price")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .padding(.vertical,2)
                    }
                    Spacer()
                    VStack(alignment: .trailing){
                        Text(locationViewModel.selectedPaymentMethod ?? "cash")
                            .font(.callout)
                        Text("\(locationViewModel.selectedRide?.estimation?.estimate ?? 0, specifier: "%.2f") \(locationViewModel.selectedRide?.estimation?.currencyCode ?? "")")
                            .font(.callout)
                            .padding(.vertical,2)
                    }
                }
                .padding(.horizontal,20)
                Divider()
                    .padding(.horizontal, 20)
                    .padding(.vertical,8)
                HStack{
                    LargeButton(
                        title: "cancel".localized(),
                        backgroundColor: Color.white,
                        foregroundColor: Color(hex: "#663A80"),
                        buttonHorizontalMargins: 0
                    ) {
                        viewModel.isCancelClicked = true
                    }
//                    Image("Message", bundle: Bundle.module)
                    Image("Call", bundle: Bundle.module)
                        .padding(.leading)
                }
                .padding(.horizontal)
                .padding(.bottom)
                
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding(.bottom, 20)
    }
}

#Preview {
    RideDetailsExpandedSheet(viewModel: RideViewModel(), locationViewModel: LocationSelectingViewModel())
}
