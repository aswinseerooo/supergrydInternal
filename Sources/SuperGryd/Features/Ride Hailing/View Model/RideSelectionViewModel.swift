//
//  RideSelectionViewModel.swift
//  
//
//  Created by Aswin V Shaji on 12/11/24.
//

//import Foundation
//
//class RideSelectionViewModel: ObservableObject {
//    @Published var errorMessage: String?
//    @Published var isLoading = false
//    @Published var priceEstimateData: RideRequestPriceEstimateResponse?
//
//    func fetchPriceEstimate(
//        startLocation: (lat: Double, long: Double),
//        endLocation: (lat: Double, long: Double)
//    ) {
//        isLoading = true
//        RideHailingServiceImpl.shared.requestPriceEstimate(
//            startLocation: startLocation,
//            endLocation: endLocation
//        ) { [weak self] result in
//            self?.isLoading = false
//            switch result {
//            case .success(let priceEstimateResponse):
//                self?.priceEstimateData = priceEstimateResponse
//                print("Price Estimation api success")
//            case .failure(let error):
//                self?.errorMessage = "Price estimate failed: \(error.localizedDescription)"
//                print("Price estimate failed: \(error.localizedDescription)")
//            }
//        }
//    }
//}

import Foundation
import SwiftUI
import BottomSheet
import CoreLocation

class RideSelectionViewModel: ObservableObject {
    // State variables
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var priceEstimateData: RideRequestPriceEstimateResponse?
    @Published var bottomSheetPosition: BottomSheetPosition = .dynamic
    @Published var isPaymentSelectionSheetShowing = false
    @Published var paymentOption: String = "cash".localized()
    @Published var paymentIcon: String = "cash"
    @Published var selectedRideIndex: Int? = nil

    // Computed property for ride options
    var rideOptions: [RideOption] {
        priceEstimateData?.data ?? []
    }

    // Initialization function
    func initialize(startLocation: (lat: Double, long: Double), endLocation: (lat: Double, long: Double)) {
        loadPriceEstimates(startLocation: startLocation, endLocation: endLocation)
    }

    // Function to load price estimates
    private func loadPriceEstimates(startLocation: (lat: Double, long: Double), endLocation: (lat: Double, long: Double)) {
        isLoading = true
        errorMessage = nil

        RideHailingServiceImpl.shared.requestPriceEstimate(
            startLocation: startLocation,
            endLocation: endLocation
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let priceEstimateResponse):
                    self?.priceEstimateData = priceEstimateResponse
                case .failure(let error):
                    self?.errorMessage = "Price estimate failed: \(error.localizedDescription)"
                }
            }
        }
    }
}
