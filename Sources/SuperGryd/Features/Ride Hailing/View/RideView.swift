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
            if viewModel.rideTrackingResponse != nil  {
                RideTrackingMapView(rideViewModel: viewModel)
                    .environmentObject(viewModel)
                    .edgesIgnoringSafeArea(.all)
            }else {
                MapView(
                    onAddressUpdate: { address in
                    },
                    onCurrentLocationUpdate: { currentLocation in
                    }
                ).edgesIgnoringSafeArea(.all)
            }
            
            
            if viewModel.isFindingRide && !viewModel.isCancelClicked {
                BackButton {
                    locationViewModel.navigationPath.removeLast()
                }
            }
            
            if viewModel.isRideCompleted {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                RideCompletedSheetView(viewModel: viewModel, locationViewModel: locationViewModel)
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
                .absolute(UIScreen.main.bounds.height * 0.2),
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
        .onChange(of: viewModel.isShowingRideDetails) { _ in
            viewModel.bottomSheetPosition = .dynamic
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
            CancelConfirmationSheet(viewModel: viewModel)
        } else if viewModel.isShowingCancelReasons {
            CancelRideSheet(locationViewModel: locationViewModel, viewModel: viewModel)
        } else if viewModel.isShowingRideDetails {
            RideDetailsExpandedSheet(viewModel: viewModel, locationViewModel: locationViewModel)
        } else if viewModel.isDriverAccepted || viewModel.isDriverPickedUp {
            DriverAcceptedSheet(viewModel: viewModel)
        } else {
            FindingRideSheet(viewModel: viewModel, locationViewModel: locationViewModel)
        }
    }
}

#Preview {
    RideView(locationViewModel: LocationSelectingViewModel())
}

