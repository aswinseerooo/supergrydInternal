//
//  LocationSelectingViewModel.swift
//
//
//  Created by Aswin V Shaji on 28/10/24.
//

import SwiftUI
import CoreLocation
import BottomSheet
import GooglePlaces

class LocationSelectingViewModel: ObservableObject {
    @Published var fromLocation: String = "Loading..."
    @Published var toLocation: String = ""
    
    @Published var locationFromMap: AutoCompleteSuggestion?
    @Published var selectedFromLocation: AutoCompleteSuggestion?
    @Published var selectedToLocation: AutoCompleteSuggestion?
    
    @Published var isLocationExpandedViewShowing: Bool = false
    @Published var isRideSelectionViewShowing: Bool = false
    @Published var isConfirmLocationOnMapShowing: Bool = false
    @Published var isFromLocationSet: Bool = false
    @Published var isFromCordinateSet: Bool = false
    @Published var showBackButton: Bool = true
    @Published var forDestinationLocation: Bool = true
    
    @Published var bottomSheetPosition: BottomSheetPosition = .dynamic
    @Published var bottomSheetOffset: CGFloat = UIScreen.main.bounds.height * 0.3
    
    @Published var navigationPath: [String] = []
    
    @Published var suggestions: [AutoCompleteSuggestion] = []
    @Published var selectedRide: RideOption?
    
    var backAction: () -> Void = {}
    var dismissAction: (() -> Void)?
    let locations = [
        AutoCompleteSuggestion(title: "Christofstraße 20", subtitle: "72127 Berlin, Germany",coordinate: CLLocationCoordinate2D(latitude: 10.064588, longitude: 76.351151)),
        AutoCompleteSuggestion(title: "Sonnenweg 32", subtitle: "79669 Berlin, Germany",coordinate: CLLocationCoordinate2D(latitude: 10.064588, longitude: 76.351151)),
        AutoCompleteSuggestion(title: "Some Other Place", subtitle: "Some Other Country",coordinate: CLLocationCoordinate2D(latitude: 10.064588, longitude: 76.351151)),
        AutoCompleteSuggestion(title: "Christofstraße 20", subtitle: "72127 Berlin, Germany",coordinate: CLLocationCoordinate2D(latitude: 10.064588, longitude: 76.351151)),
        AutoCompleteSuggestion(title: "Sonnenweg 32", subtitle: "79669 Berlin, Germany",coordinate: CLLocationCoordinate2D(latitude: 10.064588, longitude: 76.351151))
    ]
    private var placesClient: GMSPlacesClient
    init() {
        placesClient = GMSPlacesClient.shared()
    }
    func handleAddressUpdate(_ address: AutoCompleteSuggestion) {
        locationFromMap = address
    }
    
    func handleCurrentLocationUpdate(_ currentLocation: AutoCompleteSuggestion) {
        if !isFromLocationSet {
            fromLocation = currentLocation.title
            selectedFromLocation = currentLocation
            isFromLocationSet = true
        }
    }
    
    func updateBackAction(_ action: @escaping () -> Void) {
        backAction = action
    }
    
    func handleBackAction() {
        backAction()
    }
    
    func resetViewsForRideSelection() {
        isRideSelectionViewShowing = false
        isLocationExpandedViewShowing = false
        isConfirmLocationOnMapShowing = false
        isFromLocationSet = false
        isFromCordinateSet = false
        showBackButton = true
        forDestinationLocation = true
        bottomSheetPosition = .dynamic
    }
    
    func updateBottomSheetPosition(_ newPosition: BottomSheetPosition) {
        if isLocationExpandedViewShowing {
            if newPosition == .absolute(UIScreen.main.bounds.height * 0.35) {
                isConfirmLocationOnMapShowing = true
                showBackButton = true
                updateBackAction {
                    self.isLocationExpandedViewShowing = false
                    self.isConfirmLocationOnMapShowing = false
                    self.bottomSheetPosition = .dynamic
                }
            } else {
                isConfirmLocationOnMapShowing = false
                showBackButton = false
                updateBackAction { self.goBackToHostApp() }
            }
        }
    }
    
    func goBackToHostApp() {
        dismissAction?()
    }
    
    func fetchAutocompleteSuggestions(for query: String) {
        let filter = GMSAutocompleteFilter()
        
        placesClient.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { (results, error) in
            if let error = error {
                print("Error fetching autocomplete suggestions: \(error.localizedDescription)")
                return
            }
//            print("Auto Suggestion results = ", results as Any)
            
            self.suggestions = results?.compactMap { prediction in
                let primaryText = prediction.attributedPrimaryText.string
                let secondaryText = prediction.attributedSecondaryText?.string
//                print("Primary Text = \(primaryText) \n Secondary Text = \(secondaryText ?? "No Text")")
                
                // Set title as the first component, subtitle as the rest
                let title = primaryText 
                let subtitle = secondaryText
                
                return AutoCompleteSuggestion(title: title, subtitle: subtitle)
            } ?? []
            
            results?.forEach { prediction in
                let placeID = prediction.placeID
                let myProperties = [GMSPlaceProperty.coordinate].map {$0.rawValue}
                let fetchPlaceRequest = GMSFetchPlaceRequest(placeID: placeID, placeProperties: myProperties, sessionToken: nil)

                self.placesClient.fetchPlace(with: fetchPlaceRequest) { place, error in
                    if let error = error {
                        print("Error fetching place details: \(error.localizedDescription)")
                        return
                    }
                    
                    let title = prediction.attributedPrimaryText.string
                    if let place = place, let index = self.suggestions.firstIndex(where: { $0.title == title }) {
                        print("Coordinates of \(title) = ",place.coordinate)
                        self.suggestions[index].coordinate = place.coordinate
                    }
                }
            }
        }
    }
}
