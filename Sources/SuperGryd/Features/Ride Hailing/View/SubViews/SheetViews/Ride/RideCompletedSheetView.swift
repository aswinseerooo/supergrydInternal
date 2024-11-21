//
//  RideCompletedSheetView.swift
//
//
//  Created by Aswin V Shaji on 03/11/24.
//

import SwiftUI

struct RideCompletedSheetView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: RideViewModel
    @ObservedObject var locationViewModel: LocationSelectingViewModel
    var body: some View {
        ScrollView{
        VStack() {
            Image("SuccessIcon", bundle: Bundle.module)
                .padding(.top,30)
            Text("ride_completed")
                .font(.title3)
                .fontWeight(.bold)
                .padding(8)
            Text("ID\(viewModel.rideTrackingResponse?.requestID ?? "")")
                .font(.headline)
                .foregroundStyle(Color(hex: "#663A80"))
                .padding(.bottom)
            Divider()
                .padding(.horizontal, 20)
            RideInfoItemView(
                distance: Text("\(locationViewModel.selectedRide?.estimation?.distance ?? 0, specifier: "%.2f") km"),
                time: Text(viewModel.currentTime ?? ""),
                date: Text(viewModel.currentDate ?? ""),
                isRideCompletedView: true
            )
                .padding(.horizontal,20)
                .padding(.vertical,5)
            Divider()
                .padding(.horizontal, 20)
            PickupDropoffStepperView(fromLocation: $locationViewModel.fromLocation, toLocation: $locationViewModel.toLocation)
            HStack{
                HStack{
                    AsyncImage(url: URL(string: viewModel.rideTrackingResponse?.driverDetails?.pictureURL ?? "")) { image in
                        image
                            .resizable() // Ensure the image is resizable
                            .scaledToFit() // Scale the image to fit within the frame
                    } placeholder: {
                        ProgressView() // Optional placeholder while the image is loading
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    VStack(alignment: .leading){
                        Text(viewModel.rideTrackingResponse?.driverDetails?.name ?? "")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        Text(viewModel.rideTrackingResponse?.vehicle?.licensePlate ?? "")
                            .font(.footnote)
                            .fontWeight(.light)
                        Text(viewModel.rideTrackingResponse?.vehicle?.make ?? "")
                            .font(.footnote)
                            .fontWeight(.light)
                    }
                    .padding(.leading,8)
                }
                Spacer()
                HStack() {
                    VStack(alignment: .leading){
                        Text("your_trip_fare")
                            .font(.footnote)
                            .fontWeight(.light)
                        Text("payment_option")
                            .font(.footnote)
                            .fontWeight(.light)
                    }
                    VStack(alignment: .leading){
                        Text("\(locationViewModel.selectedRide?.estimation?.estimate ?? 0, specifier: "%.2f") \(locationViewModel.selectedRide?.estimation?.currencyCode ?? "")")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        Text(locationViewModel.selectedPaymentMethod ?? "")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding(.horizontal,20)
            HStack{
                LargeButton(
                    title: "booking_history".localized(),
                    backgroundColor: Color.white,
                    foregroundColor: Color(hex: "#6C7B88"),
                    buttonHorizontalMargins: 0,
                    cornerRadius: 8
                ) {
                    
                }
                Spacer()
                LargeButton(
                    title: "rate_this_ride".localized(),
                    backgroundColor: Color.white,
                    foregroundColor: Color(hex: "#6C7B88"),
                    buttonHorizontalMargins: 0,
                    cornerRadius: 8
                ) {
                    locationViewModel.navigationPath.append("RateDriverView")
                }
            }
            .padding(.horizontal,20)
            Image("SeparatorDotted", bundle: Bundle.module)
                .resizable()
                .padding(.horizontal,20)
                .padding(.vertical,8)
            HStack {
                Text("recommended_services")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal,20)
            Image("recommendedService", bundle: Bundle.module)
                .resizable()
                .frame(height: 150)
                .padding(.bottom, 20)
                .padding(.horizontal,20)
            Button{
                locationViewModel.navigationPath = []
            }label: {
                Text("close")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
            }
            .padding(.bottom, 20)
        }
        .frame(width: UIScreen.main.bounds.width - 35)
    }
        .scrollIndicators(.hidden)
        .frame(width: UIScreen.main.bounds.width - 35)
            .background(Color(.systemBackground))
            .cornerRadius(20)
    }
}

#Preview {
    RideCompletedSheetView(viewModel: RideViewModel(), locationViewModel: LocationSelectingViewModel())
}
