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
    @Published var rideTrackingResponse: RideTrackingResponse?
    @Published var otp: Int?
    @Published var currentTime: String?
    @Published var currentDate: String?
    @Published var fromLocation: CLLocationCoordinate2D?
    @Published var toLocation: CLLocationCoordinate2D?
    @Published var initialDriverLocation: CLLocationCoordinate2D?
    @Published var currentDriverLocation: CLLocationCoordinate2D?
    
    let driverInfo = driverInfoMockData
    let tripInfo = tripInfoMockData
    
    // Lifecycle Methods
    func onAppear(rideRequest : RideBookingRequest) {
        if isFindingRide {
            bookRide(rideRequest: rideRequest)
            fetchCancelReasons()
        }
    }
    
    private func bookRide(rideRequest: RideBookingRequest) {
        let rideService = RideHailingServiceImpl.shared
        fromLocation = CLLocationCoordinate2DMake(rideRequest.startLocation.lat, rideRequest.startLocation.long)
        toLocation = CLLocationCoordinate2DMake(rideRequest.endLocation.lat, rideRequest.endLocation.long)
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
                DispatchQueue.global().asyncAfter(deadline: .now() + 4) {
                    rideService.trackRide(requestId: response.data?.requestedID ?? 0) { result in
                        switch result {
                        case .success(let response):
                            self.rideTrackingResponse = response
                            if self.initialDriverLocation == nil {
                                print("Driver Initial Location is nil")
                                self.initialDriverLocation = CLLocationCoordinate2D(latitude: Double(response.driverLat ?? "0") ?? 0, longitude: Double(response.driverLng ?? "0") ?? 0)
                            }
                            self.currentDriverLocation = CLLocationCoordinate2D(latitude: Double(response.driverLat ?? "0") ?? 0, longitude: Double(response.driverLng ?? "0") ?? 0)
                            if let otpValue = response.otp, self.otp == nil {
                                self.otp = otpValue
                            }
                            switch response.rideStatus {
                            case 1:
                                self.isFindingRide = false
                                self.isDriverAccepted = true
                                self.titleText = "pick_up_in_6_min".localized()
                                
                            case 2:
                                self.titleText = "your_ride_is_on_the_way".localized()
                                
                            case 3:
                                self.titleText = "your_ride_is_here".localized()
                                
                            case 4, 5:
                                self.isDriverAccepted = false
                                self.isDriverPickedUp = true
                                
                            default:
                                self.isDriverPickedUp = false
                                self.isRideCompleted = true
                                
                                // Capture current date and time
                                let currentDate = Date()
                                let timeFormatter = DateFormatter()
                                timeFormatter.dateFormat = "hh:mma" // Format for time, e.g., 07:48AM
                                let timeString = timeFormatter.string(from: currentDate)
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "dd MMM yyyy" // Format for date, e.g., 28 Nov 2024
                                let dateString = dateFormatter.string(from: currentDate)
                                
                                // Save the formatted time and date
                                self.currentTime = timeString
                                self.currentDate = dateString
                            }
                            
                        case .failure(let error):
                            print("Error Tracking Ride: \(error.localizedDescription)")
                        }
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
    
    func cancelRide(completion: @escaping (Bool) -> Void) {
        RideHailingServiceImpl.shared.cancelRide(requestId: bookRideResponse?.data?.requestedID ?? 0, reasonId: selectedCancelReason?.reasonID ?? 0, reason: selectedCancelReason?.reason ?? "") { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let cancelStatus):
                    completion(true)
                case .failure(let error):
                    print("Failed to cancel ride reasons: \(error.localizedDescription)")
                }
            }
        }
    }
}

