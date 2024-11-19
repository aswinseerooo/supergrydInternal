//
//  RideSelectionView.swift
//
//
//  Created by Aswin V Shaji on 25/10/24.
//

//import SwiftUI
//import CoreLocation
//import BottomSheet
//
//struct RideSelectionView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @Environment(\.colorScheme) var colorScheme
//    @Binding var isRideSelectionViewShowing: Bool
//    @Binding var navigationPath: [String]
//    @State private var isPaymentSelectionSheetShowing = false
//    @State private var payemntOption: String = "cash".localized()
//    @State private var paymentIcon: String = "cash"
//    @State var bottomSheetPosition: BottomSheetPosition = .dynamic
//    @State private var selectedRideIndex: Int? = nil
//    @StateObject private var viewModel = RideSelectionViewModel()
//    let startLocation: (lat: Double, long: Double)
//    let endLocation: (lat: Double, long: Double)
//    var body: some View {
//        ZStack() {
//            
//            MapView(onAddressUpdate: { address in
//                
//            }, onCurrentLocationUpdate: { currentLocation in
//                
//            })
//                .edgesIgnoringSafeArea(.all)
////                        colorScheme == .dark
////                        ? Color.white
////                            .ignoresSafeArea()
////                        : Color.black
////                            .ignoresSafeArea()
//            BackButton(function: {
//                isRideSelectionViewShowing = false
//                navigationPath.removeLast()
//            })
//        }
//        .navigationBarTitle("")
//        .toolbar(.hidden)
//        .navigationBarBackButtonHidden(true)
//        .bottomSheet(
//            bottomSheetPosition: $bottomSheetPosition,
//            switchablePositions: [.dynamic ]
//        ) {
//            sheetContentView().padding(.horizontal)
//        }
//        .customBackground(.clear)
//        .dragIndicatorColor(.clear)
//        .enableContentDrag(false)
//        .onAppear {
//            viewModel.fetchPriceEstimate(
//                startLocation: (lat: startLocation.lat, long: startLocation.long),
//                endLocation: (lat: endLocation.lat, long: endLocation.long)
//            )
//        }
//    }
//    
//    @ViewBuilder
//    private func sheetContentView() -> some View {
//        if !(viewModel.errorMessage == nil) {
//            RideNotFoundSheet()
//        } else {
//            if isPaymentSelectionSheetShowing{
//                PaymentSelectionSheet(isPaymentSelectionSheetShowing: $isPaymentSelectionSheetShowing, paymentIcon: $paymentIcon, paymentOption: $payemntOption)
//            }else{
//                RideSelectionSheet(selectedRideIndex: $selectedRideIndex, isPaymentSelectionSheetShowing: $isPaymentSelectionSheetShowing, paymentOption: $payemntOption,paymentIcon: $paymentIcon, isLoading: $viewModel.isLoading, navigationPath: $navigationPath, rideOptions: viewModel.priceEstimateData?.data ?? [])
//            }
//        }
//    }
//}
//
//
//#Preview {
//    RideSelectionView(isRideSelectionViewShowing: .constant(true), navigationPath: .constant([]), startLocation: (lat: 10.055348, long: 76.321888), endLocation: (lat: 10.064588, long: 76.351151))
//}

import SwiftUI
import CoreLocation
import BottomSheet

struct RideSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var locationViewModel: LocationSelectingViewModel
    @StateObject private var viewModel = RideSelectionViewModel()
    let startLocation: (lat: Double, long: Double)
    let endLocation: (lat: Double, long: Double)

    var body: some View {
        ZStack {
            MapView(onAddressUpdate: { address in
            }, onCurrentLocationUpdate: { currentLocation in
            })
            .edgesIgnoringSafeArea(.all)

            BackButton(function: {
                locationViewModel.isRideSelectionViewShowing = false
                locationViewModel.navigationPath.removeLast()
            })
        }
        .navigationBarTitle("")
        .toolbar(.hidden)
        .navigationBarBackButtonHidden(true)
        .bottomSheet(
            bottomSheetPosition: $viewModel.bottomSheetPosition,
            switchablePositions: [.dynamic]
        ) {
            sheetContentView().padding(.horizontal)
        }
        .customBackground(.clear)
        .dragIndicatorColor(.clear)
        .enableContentDrag(false)
        .onAppear {
            viewModel.initialize(startLocation: startLocation, endLocation: endLocation)
        }
    }

    @ViewBuilder
    private func sheetContentView() -> some View {
        if let errorMessage = viewModel.errorMessage {
            RideNotFoundSheet()
        } else {
            if viewModel.isPaymentSelectionSheetShowing {
                PaymentSelectionSheet(
                    viewModel: viewModel
                )
            } else {
                RideSelectionSheet(locationViewModel: locationViewModel, viewModel: viewModel)
            }
        }
    }
}

#Preview {
    RideSelectionView(
        locationViewModel: LocationSelectingViewModel(),
        startLocation: (lat: 10.055348, long: 76.321888),
        endLocation: (lat: 10.064588, long: 76.351151)
    )
}
