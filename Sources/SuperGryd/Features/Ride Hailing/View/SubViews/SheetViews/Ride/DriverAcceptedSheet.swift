//
//  DriverAcceptedSheet.swift
//
//
//  Created by Aswin V Shaji on 31/10/24.
//

import SwiftUI

struct DriverAcceptedSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: RideViewModel
    var body: some View {
        VStack() {
            // Display total distance covered
            Rectangle()
                .frame(width: 50,height: 5)
                .foregroundStyle(Color(hex: "#F1F5F9"))
                .padding()
            if !viewModel.isDriverPickedUp {
                Text(viewModel.titleText)
                   .font(.title3)
                   .fontWeight(.bold)
               Divider()
                   .padding(.horizontal, 20)
                   .padding(.vertical,8)
            }
            HStack{
                if viewModel.isDriverPickedUp {
                    Text("ongoing_ride")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                    Text("5_min_away_from_destination")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }else{
                    Text("pin_for_this_trip")
                        .font(.subheadline)
                    Spacer()
                    if let otp = viewModel.otp {
                        let otpDigits = String(otp).compactMap { Int(String($0)) }
                        ForEach(otpDigits, id: \.self) { pinDigit in
                            Rectangle()
                                .foregroundStyle(Color(hex: "#663A80"))
                                .frame(width: 30, height: 35)
                                .overlay(Text("\(pinDigit)").foregroundStyle(.white))
                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 5)
                        }
                    }
                }
            }
            .padding(.horizontal,20)
            Divider()
                .padding(.horizontal, 20)
                .padding(.vertical,8)
            HStack() {
                ZStack(alignment: .bottom){
                    AsyncImage(url: URL(string: viewModel.rideTrackingResponse?.vehicle?.pictureURL ?? "")) { image in
                        image
                            .resizable() // Ensure the image is resizable
                            .scaledToFit() // Scale the image to fit within the frame
                    } placeholder: {
                        ProgressView() // Optional placeholder while the image is loading
                    }
                        .scaledToFit()
                        .frame(width: 100, height: 100,alignment: .bottom)
                        .offset(x:65)
                    
                    AsyncImage(url: URL(string: viewModel.rideTrackingResponse?.driverDetails?.pictureURL ?? "")) { image in
                        image
                            .resizable() // Ensure the image is resizable
                            .scaledToFit() // Scale the image to fit within the frame
                    } placeholder: {
                        ProgressView() // Optional placeholder while the image is loading
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                }
                Spacer()
                VStack(alignment: .trailing){
                    Text(viewModel.rideTrackingResponse?.driverDetails?.name ?? "")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    Text(viewModel.rideTrackingResponse?.vehicle?.licensePlate ?? "")
                        .font(.headline)
                        .lineLimit(1)
                        .padding(.bottom,2)
                    Text("\(viewModel.rideTrackingResponse?.vehicle?.make ?? "") \(viewModel.rideTrackingResponse?.vehicle?.model ?? "")")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
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
                if !viewModel.isDriverPickedUp {
//                    Image("Message", bundle: Bundle.module)
                    Image("Call", bundle: Bundle.module)
                        .padding(.leading)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding(.bottom, 20)
    }
}

#Preview {
    DriverAcceptedSheet(viewModel: RideViewModel())
}
