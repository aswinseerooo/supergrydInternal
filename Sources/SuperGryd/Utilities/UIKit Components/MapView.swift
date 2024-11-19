//
//  MapView.swift
//
//
//  Created by Aswin V Shaji on 21/10/24.
//

import SwiftUI
import CoreLocation
import GoogleMaps
import GooglePlaces

struct MapView: UIViewRepresentable {
    var onAddressUpdate: (AutoCompleteSuggestion) -> Void
    var onCurrentLocationUpdate: (AutoCompleteSuggestion) -> Void
    
    class Coordinator: NSObject, CLLocationManagerDelegate, GMSMapViewDelegate {
        var mapView: GMSMapView?
        var locationManager = CLLocationManager()
        var placesClient = GMSPlacesClient.shared()
        
        var onAddressUpdate: (AutoCompleteSuggestion) -> Void
        var onCurrentLocationUpdate: (AutoCompleteSuggestion) -> Void
        
        var shouldCenterOnUserLocation = true
        
        init(onAddressUpdate: @escaping (AutoCompleteSuggestion) -> Void,
             onCurrentLocationUpdate: @escaping (AutoCompleteSuggestion) -> Void) {
            self.onAddressUpdate = onAddressUpdate
            self.onCurrentLocationUpdate = onCurrentLocationUpdate
        }
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            // Fetch nearby place name based on the map’s center after dragging
            fetchNearbyPlaceName(coordinate: position.target, forUserLocation: false)
            shouldCenterOnUserLocation = false
        }
        
        private func createBounds(for coordinate: CLLocationCoordinate2D, radius: Double) -> GMSCoordinateBounds {
            // 1 degree latitude ~= 111 km, so 100 meters is ~0.0009 degrees
            let delta = radius / 111000.0 // Convert radius to degrees
            
            let northEast = CLLocationCoordinate2D(latitude: coordinate.latitude + delta, longitude: coordinate.longitude + delta)
            let southWest = CLLocationCoordinate2D(latitude: coordinate.latitude - delta, longitude: coordinate.longitude - delta)
            
            return GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        }
        
        func fetchNearbyPlaceName(coordinate: CLLocationCoordinate2D, forUserLocation: Bool) {
            
            let apiKey = "AIzaSyA_VcC8o95gW_Fo5efpVkMJCtn4DV4CsYg"
            
            RideHailingServiceImpl.shared.requestNearbyPlaces(latitude: coordinate.latitude, longitude: coordinate.longitude, radius: 50, apiKey: apiKey) { result in
                switch result {
                case .success(let response):
                    if let placeName = response.places?.first?.displayName?.text {
                        let filter = GMSAutocompleteFilter()
                        // Define the bounds for a 100-meter radius
                        let radius: Double = 50 // in meters
                        let region = self.createBounds(for: coordinate, radius: radius)
                        
                        // Strictly restrict results to this region
                        filter.locationRestriction = GMSPlaceRectangularLocationOption(region.northEast, region.southWest)
                        self.placesClient.findAutocompletePredictions(fromQuery: placeName, filter: filter, sessionToken: nil) { (results, error) in
                            if let error = error {
                                print("Error fetching autocomplete suggestions: \(error.localizedDescription)")
                                return
                            }
//                            print("Auto Suggestion results = ", results as Any)
                            let primaryText = results?.first?.attributedPrimaryText.string
                            let secondaryText = results?.first?.attributedSecondaryText?.string
                            if forUserLocation {
                                self.onCurrentLocationUpdate(AutoCompleteSuggestion(title: primaryText ?? "", subtitle: secondaryText, coordinate: coordinate))
                            } else {
                                self.onAddressUpdate(AutoCompleteSuggestion(title: primaryText ?? "", subtitle: secondaryText, coordinate: coordinate))
                            }
                        }
                    } else {
                        print("No place name found.")
                    }
                case .failure(let error):
                    print("Error fetching nearby places: \(error.localizedDescription)")
                }
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let userLocation = locations.first else { return }
            fetchNearbyPlaceName(coordinate: userLocation.coordinate, forUserLocation: true)
            
            if shouldCenterOnUserLocation {
                centerUserLocation(userLocation.coordinate)
            }
        }
        
        private func centerUserLocation(_ coordinate: CLLocationCoordinate2D) {
            guard let mapView = mapView else { return }
            let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
                                                  longitude: coordinate.longitude,
                                                  zoom: 16)
            mapView.camera = camera
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse {
                locationManager.startUpdatingLocation()
                mapView?.isMyLocationEnabled = true
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(
            onAddressUpdate: onAddressUpdate,
            onCurrentLocationUpdate: onCurrentLocationUpdate
        )
    }
    
    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView()
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        context.coordinator.mapView = mapView
        context.coordinator.locationManager.requestWhenInUseAuthorization()
        context.coordinator.locationManager.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // Optional: Implement if further updates are required.
    }
}
