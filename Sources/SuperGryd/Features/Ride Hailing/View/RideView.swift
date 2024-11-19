//
//  RideView.swift
//
//
//  Created by Aswin V Shaji on 29/10/24.
//


import SwiftUI
import CoreLocation
import BottomSheet

struct RideView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = RideViewModel()
    @ObservedObject var locationViewModel: LocationSelectingViewModel
    
    var body: some View {
        ZStack {
            MapView(
                onAddressUpdate: { address in
                },
                onCurrentLocationUpdate: { currentLocation in
                }
            )
            .edgesIgnoringSafeArea(.all)
            
            if viewModel.isFindingRide && !viewModel.isCancelClicked {
                BackButton {
                    locationViewModel.navigationPath.removeLast()
                }
            }
            
            if viewModel.isRideCompleted {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                RideCompletedSheetView(navigationPath: $locationViewModel.navigationPath)
                    .frame(width: UIScreen.main.bounds.width - 35)
            }
        }
        .navigationBarTitle("")
        .toolbar(.hidden)
        .navigationBarBackButtonHidden(true)
        .bottomSheet(
            bottomSheetPosition: $viewModel.bottomSheetPosition,
            switchablePositions: viewModel.isCancelClicked || viewModel.isShowingCancelReasons ? [.dynamic] : [
                .absolute(UIScreen.main.bounds.height * 0.6),
                .dynamic
            ]
        ) {
            if !viewModel.isRideCompleted {
                sheetContentView().padding(.horizontal)
            }
        }
        .customBackground(.clear)
        .dragIndicatorColor(.clear)
        .enableContentDrag(!viewModel.isCancelClicked && !viewModel.isShowingCancelReasons)
        .onChange(of: viewModel.bottomSheetPosition) { newValue in
            if newValue == .absolute(UIScreen.main.bounds.height * 0.6) && !viewModel.isCancelClicked && !viewModel.isShowingCancelReasons && !viewModel.isFindingRide {
                viewModel.isShowingRideDetails.toggle()
            }
        }
        .onChange(of: viewModel.isCancelClicked) { _ in
            viewModel.bottomSheetPosition = .dynamic
        }
        .onChange(of: viewModel.isDriverAccepted) { _ in
            viewModel.handleDriverAccepted()
        }
        .onChange(of: viewModel.isDriverPickedUp) { _ in
            viewModel.handleDriverPickedUp()
        }
        .onAppear {
            let rideRequest = RideBookingRequest(
                firstName: "Aswin",
                lastName: "Achuz",
                phoneNumber: "1234567890",
                email: "aswin@mailinator.com",
//                startLocation: .init(
//                    lat: locationViewModel.selectedFromLocation?.coordinate?.latitude ?? 0,
//                    long: locationViewModel.selectedFromLocation?.coordinate?.longitude ?? 0,
//                    address: locationViewModel.selectedFromLocation?.title ?? ""
//                ),
//                endLocation: .init(
//                    lat: locationViewModel.selectedToLocation?.coordinate?.latitude ?? 0,
//                    long: locationViewModel.selectedToLocation?.coordinate?.longitude ?? 0,
//                    address: locationViewModel.selectedToLocation?.title ?? ""
//                ),
                startLocation: .init(lat: 10.055348, long: 76.321888, address: "Devalokam, Thevakal"),
                endLocation: .init(lat: 10.064588, long: 76.351151, address: "Seeroo IT Solutions"),
                productId: locationViewModel.selectedRide?.estimation?.productID ?? "",
                fareId: "\(locationViewModel.selectedRide?.estimation?.fareID ?? 0)",
                userId: AppConstants.userId,
                price: locationViewModel.selectedRide?.estimation?.estimate ?? 0
            )
            viewModel.onAppear(rideRequest: rideRequest)
        }
    }
    
    @ViewBuilder
    private func sheetContentView() -> some View {
        if viewModel.isNoRideAvailable {
            RideNotFoundSheet()
        } else if viewModel.isCancelClicked {
            CancelConfirmationSheet(
                isCancelClicked: $viewModel.isCancelClicked,
                isShowingCancelReasons: $viewModel.isShowingCancelReasons,
                isFindingRide: $viewModel.isFindingRide
            )
        } else if viewModel.isShowingCancelReasons {
            CancelRideSheet(locationViewModel: locationViewModel, viewModel: viewModel)
        } else if viewModel.isShowingRideDetails {
            RideDetailsExpandedSheet(
                isCancelClicked: $viewModel.isCancelClicked,
                tripInfo: viewModel.tripInfo,
                driverInfo: viewModel.driverInfo
            )
        } else if viewModel.isDriverAccepted || viewModel.isDriverPickedUp {
            DriverAcceptedSheet(
                isCancelClicked: $viewModel.isCancelClicked,
                isDriverPickedUp: $viewModel.isDriverPickedUp,
                tripInfo: viewModel.tripInfo,
                driverInfo: viewModel.driverInfo,
                title: $viewModel.titleText
            )
        } else {
            FindingRideSheet(isCancelClicked: $viewModel.isCancelClicked)
        }
    }
}

#Preview {
    RideView(locationViewModel: LocationSelectingViewModel())
}

