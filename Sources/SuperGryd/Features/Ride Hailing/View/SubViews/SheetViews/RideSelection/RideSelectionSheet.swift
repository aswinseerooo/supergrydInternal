//
//  RideSelectionSheet.swift
//
//
//  Created by Aswin V Shaji on 26/10/24.
//

import SwiftUI

struct RideSelectionSheet: View {
    @ObservedObject var locationViewModel: LocationSelectingViewModel
    @ObservedObject var viewModel: RideSelectionViewModel
    
    var body: some View {
        VStack() {
            // Display total distance covered
            Text(viewModel.isLoading ? "gathering_options" : "choose_your_ride")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
                .padding(.top)
                .frame(maxWidth: .infinity,alignment: .leading)
            if viewModel.isLoading{
                LoadingProgressBar()
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            VStack{
                if viewModel.isLoading {
                    ForEach((1...3), id: \.self) { _ in
                        RideSelectionTile(
                            rideOption: RideOptionMockData,
                            isSelected: false
                        )
                        }
                } else {
                    ForEach(viewModel.rideOptions.indices, id: \.self) { index in
                        RideSelectionTile(
                            rideOption: viewModel.rideOptions[index],
                            isSelected: viewModel.selectedRideIndex == index
                        )
                        .onAppear {
                            if !viewModel.isLoading{
                                locationViewModel.selectedRide = viewModel.rideOptions[0]
                            }
                        }
                        .onTapGesture {
                            if !viewModel.isLoading{
                                viewModel.selectedRideIndex = index
                                locationViewModel.selectedRide = viewModel.rideOptions[viewModel.selectedRideIndex ?? 0]
                            }
                        }
                    }
                }
                VStack {
                    if viewModel.isLoading {
                        RideInfoItemView(distance: "21 km", time: rideOptionsMockData[viewModel.selectedRideIndex ?? 0].expectedArrivalTime, price: rideOptionsMockData[viewModel.selectedRideIndex ?? 0].price)
                            .padding(.horizontal,40)
                            .padding(.vertical,8)
                    } else {
                        if let index = viewModel.selectedRideIndex, viewModel.rideOptions.indices.contains(index) {
                            let selectedOption = viewModel.rideOptions[index]
                            RideInfoItemView(
                                distance: "\(selectedOption.estimation?.distance ?? 0) km",
                                time: "\((selectedOption.estimation?.duration ?? 0) / 60) min",
                                price: "\(selectedOption.estimation?.estimate ?? 0)"
                            )
                            .padding(.horizontal,40)
                            .padding(.vertical,8)
                        }
                    }
                }
                HStack{
                    Text("pay_using")
                        .font(.caption)
                    Spacer()
                    HStack{
                        Image(viewModel.paymentIcon, bundle: Bundle.module)
                            .padding(.leading, 5)
                        Text(viewModel.paymentOption)
                            .font(.caption)
                            .padding(.trailing, 5)
                    }
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke( Color(hex: "#663A80") , lineWidth: 1.5)
                    )
                    .onTapGesture {
                        if !viewModel.isLoading {
                            viewModel.isPaymentSelectionSheetShowing = true
                        }
                    }
                    Image("arrowRight",bundle: Bundle.module)
                }
                .padding(.horizontal, 40)
                .padding(.vertical,8)
                ZStack{
                    Color(hex: "#663A80")
                    HStack{
                        Text("request")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.leading, 40)
                        Spacer()
                        if viewModel.isLoading {
                            Text(rideOptionsMockData[viewModel.selectedRideIndex ?? 0].price)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)                        } else {
                                    if let index = viewModel.selectedRideIndex, viewModel.rideOptions.indices.contains(index) {
                                        let selectedOption = viewModel.rideOptions[index]
                                Text("\(selectedOption.estimation?.estimate ?? 0, specifier: "%.2f")")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                            }
                        }
                        ZStack {
                            Circle()
                                .foregroundStyle(.white)
                                .padding(14)
                            Image("arrowRightRounded", bundle: Bundle.module)
                        }
                    }
                }
                .frame(height: 80)
                .cornerRadius(50)
                .padding(.horizontal)
                .padding(.bottom)
                .onTapGesture {
                    if !viewModel.isLoading{
                        locationViewModel.navigationPath.append("RideView")
                    }
                }
            }
            .shimmer(when: $viewModel.isLoading)
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding(.bottom, 20)
        .onAppear {
            viewModel.selectedRideIndex = 0
        }
    }
}
#Preview {
    RideSelectionSheet(locationViewModel: LocationSelectingViewModel(), viewModel: RideSelectionViewModel())
}
