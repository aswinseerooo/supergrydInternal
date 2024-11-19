//
//  RideViewModel.swift
//
//
//  Created by Aswin V Shaji on 18/11/24.
//

import SwiftUI
import CoreLocation
import BottomSheet

class RideViewModel: ObservableObject {
    // States
    @Published var isFindingRide = true
    @Published var isNoRideAvailable = false
    @Published var isDriverAccepted = false
    @Published var isDriverPickedUp = false
    @Published var isRideCompleted = false
    @Published var isCancelClicked = false
    @Published var isShowingCancelReasons = false
    @Published var isShowingRideDetails = false
    @Published var titleText = "Pick-up in 6 min"
    @Published var bottomSheetPosition: BottomSheetPosition = .dynamic
    @Published var cancelReasons: [CancelReasonData] = []
    @Published var bookRideResponse: RideBookingResponse?
    @Published var selectedCancelReason: CancelReasonData?
    
    
    let driverInfo = driverInfoMockData
    let tripInfo = tripInfoMockData
    
    // Lifecycle Methods
    func onAppear(rideRequest : RideBookingRequest) {
        bookRide(rideRequest: rideRequest)
        fetchCancelReasons()
    }
    
    private func bookRide(rideRequest: RideBookingRequest) {
        let rideService = RideHailingServiceImpl.shared
        rideService.bookRide(
            firstName: rideRequest.firstName,
            lastName: rideRequest.lastName,
            phoneNumber: rideRequest.phoneNumber,
            email: rideRequest.email,
            startLocation: (
                rideRequest.startLocation.lat,
                rideRequest.startLocation.long,
                rideRequest.startLocation.address
            ),
            endLocation: (
                rideRequest.endLocation.lat,
                rideRequest.endLocation.long,
                rideRequest.endLocation.address
            ),
            productId: rideRequest.productId,
            fareId: rideRequest.fareId,
            userId: rideRequest.userId,
            price: rideRequest.price
        ) { result in
            switch result {
            case .success(let response):
                self.bookRideResponse = response
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                    guard let self = self else { return }
                    if self.isFindingRide {
                        self.isFindingRide = false
                        self.isDriverAccepted = true
                        self.titleText = "pick_up_in_6_min".localized()
                        simulateRideProgress()
                    }
                }
            case .failure(let error):
                print("Failed to book ride: \(error.localizedDescription)")
                self.isNoRideAvailable = true
            }
        }
    }
    
    private func fetchCancelReasons() {
        RideHailingServiceImpl.shared.fetchCancelReasons { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let reasons):
                        self.cancelReasons = reasons.data ?? []
                case .failure(let error):
                    print("Failed to fetch cancel reasons: \(error.localizedDescription)")
                }
            }
        }
    }

    
    // Simulate ride progress
    private func simulateRideProgress() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [weak self] in
            if self?.isDriverAccepted == true {
                self?.titleText = "your_ride_is_on_the_way".localized()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 9) { [weak self] in
            if self?.isDriverAccepted == true {
                self?.titleText = "your_ride_is_here".localized()
            }
        }
    }
    
    // Handle driver acceptance
    func handleDriverAccepted() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            guard let self = self else { return }
            if self.isDriverAccepted {
                self.isDriverAccepted = false
                self.isDriverPickedUp = true
            }
        }
    }
    
    // Handle driver pickup
    func handleDriverPickedUp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) { [weak self] in
            guard let self = self else { return }
            if self.isDriverPickedUp {
                self.isDriverPickedUp = false
                self.isRideCompleted = true
            }
        }
    }
    
    func cancelRide(completion: @escaping (Bool) -> Void) {
        RideHailingServiceImpl.shared.cancelRide(requestId: bookRideResponse?.data?.requestedID ?? 0, reasonId: selectedCancelReason?.reasonID ?? 0, reason: selectedCancelReason?.reason ?? "") { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let cancelStatus):
                    print("Cancel Status = ", cancelStatus.message as Any)
                        completion(true)
                case .failure(let error):
                    print("Failed to fetch cancel reasons: \(error.localizedDescription)")
                }
            }
        }
    }
}

