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
    
//    class Coordinator: NSObject, CLLocationManagerDelegate, GMSMapViewDelegate {
//        var mapView: GMSMapView?
//        var locationManager = CLLocationManager()
//        var placesClient = GMSPlacesClient.shared()
//        
//        var onAddressUpdate: (AutoCompleteSuggestion) -> Void
//        var onCurrentLocationUpdate: (AutoCompleteSuggestion) -> Void
//        
//        var shouldCenterOnUserLocation = true
//        var lastFetchedCoordinate: CLLocationCoordinate2D?
//        let coordinateThreshold: CLLocationDistance = 2
//        init(onAddressUpdate: @escaping (AutoCompleteSuggestion) -> Void,
//             onCurrentLocationUpdate: @escaping (AutoCompleteSuggestion) -> Void) {
//            self.onAddressUpdate = onAddressUpdate
//            self.onCurrentLocationUpdate = onCurrentLocationUpdate
//        }
//        
//        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//            // Fetch nearby place name based on the map’s center after dragging
//            fetchNearbyPlaceName(coordinate: position.target, forUserLocation: false)
//            shouldCenterOnUserLocation = false
//        }
//        
//        private func createBounds(for coordinate: CLLocationCoordinate2D, radius: Double) -> GMSCoordinateBounds {
//            // 1 degree latitude ~= 111 km, so 100 meters is ~0.0009 degrees
//            let delta = radius / 111000.0 // Convert radius to degrees
//            
//            let northEast = CLLocationCoordinate2D(latitude: coordinate.latitude + delta, longitude: coordinate.longitude + delta)
//            let southWest = CLLocationCoordinate2D(latitude: coordinate.latitude - delta, longitude: coordinate.longitude - delta)
//            
//            return GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
//        }
//        
//        func fetchNearbyPlaceName(coordinate: CLLocationCoordinate2D, forUserLocation: Bool) {
//            guard shouldFetchNearbyPlaces(for: coordinate) else { return }
//            
//            lastFetchedCoordinate = coordinate // Update the last fetched coordinate
//            
//            let apiKey = "AIzaSyA_VcC8o95gW_Fo5efpVkMJCtn4DV4CsYg"
//            
//            RideHailingServiceImpl.shared.requestNearbyPlaces(latitude: coordinate.latitude, longitude: coordinate.longitude, radius: 50, apiKey: apiKey) { result in
//                switch result {
//                case .success(let response):
//                    if let placeName = response.places?.first?.displayName?.text {
//                        let filter = GMSAutocompleteFilter()
//                        let radius: Double = 50
//                        let region = self.createBounds(for: coordinate, radius: radius)
//                        filter.locationRestriction = GMSPlaceRectangularLocationOption(region.northEast, region.southWest)
//                        
//                        self.placesClient.findAutocompletePredictions(fromQuery: placeName, filter: filter, sessionToken: nil) { (results, error) in
//                            if let error = error {
//                                print("Error fetching autocomplete suggestions: \(error.localizedDescription)")
//                                return
//                            }
//                            let primaryText = results?.first?.attributedPrimaryText.string
//                            let secondaryText = results?.first?.attributedSecondaryText?.string
//                            let suggestion = AutoCompleteSuggestion(title: primaryText ?? "", subtitle: secondaryText, coordinate: coordinate)
//                            
//                            if forUserLocation {
//                                self.onCurrentLocationUpdate(suggestion)
//                            } else {
//                                self.onAddressUpdate(suggestion)
//                            }
//                        }
//                    } else {
//                        print("No place name found.")
//                    }
//                case .failure(let error):
//                    print("Error fetching nearby places: \(error.localizedDescription)")
//                }
//            }
//        }
//
//        private func shouldFetchNearbyPlaces(for coordinate: CLLocationCoordinate2D) -> Bool {
//            guard let lastCoordinate = lastFetchedCoordinate else {
//                return true // Always fetch for the first time
//            }
//            let currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//            let previousLocation = CLLocation(latitude: lastCoordinate.latitude, longitude: lastCoordinate.longitude)
//            return currentLocation.distance(from: previousLocation) > coordinateThreshold
//        }
//
//        
//        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            guard let userLocation = locations.first else { return }
//            fetchNearbyPlaceName(coordinate: userLocation.coordinate, forUserLocation: true)
//            
//            if shouldCenterOnUserLocation {
//                centerUserLocation(userLocation.coordinate)
//            }
//        }
//        
//        private func centerUserLocation(_ coordinate: CLLocationCoordinate2D) {
//            guard let mapView = mapView else { return }
//            let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
//                                                  longitude: coordinate.longitude,
//                                                  zoom: 16)
//            mapView.camera = camera
//        }
//        
//        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//            if status == .authorizedWhenInUse {
//                locationManager.startUpdatingLocation()
//                mapView?.isMyLocationEnabled = true
//            }
//        }
//    }
    
    class Coordinator: NSObject, CLLocationManagerDelegate, GMSMapViewDelegate {
        var mapView: GMSMapView?
        var locationManager = CLLocationManager()
        var placesClient = GMSPlacesClient.shared()
        
        var onAddressUpdate: (AutoCompleteSuggestion) -> Void
        var onCurrentLocationUpdate: (AutoCompleteSuggestion) -> Void
        
        var userLocationMarker: GMSMarker? // Marker for the user's location
        var shouldCenterOnUserLocation = true
        var lastFetchedCoordinate: CLLocationCoordinate2D?
        let coordinateThreshold: CLLocationDistance = 2
        
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
            guard shouldFetchNearbyPlaces(for: coordinate) else { return }
            
            lastFetchedCoordinate = coordinate // Update the last fetched coordinate
            
            let apiKey = "AIzaSyA_VcC8o95gW_Fo5efpVkMJCtn4DV4CsYg"
            
            RideHailingServiceImpl.shared.requestNearbyPlaces(latitude: coordinate.latitude, longitude: coordinate.longitude, radius: 50, apiKey: apiKey) { result in
                switch result {
                case .success(let response):
                    if let placeName = response.places?.first?.displayName?.text {
                        let filter = GMSAutocompleteFilter()
                        let radius: Double = 50
                        let region = self.createBounds(for: coordinate, radius: radius)
                        filter.locationRestriction = GMSPlaceRectangularLocationOption(region.northEast, region.southWest)
                        
                        self.placesClient.findAutocompletePredictions(fromQuery: placeName, filter: filter, sessionToken: nil) { (results, error) in
                            if let error = error {
                                print("Error fetching autocomplete suggestions: \(error.localizedDescription)")
                                return
                            }
                            let primaryText = results?.first?.attributedPrimaryText.string
                            let secondaryText = results?.first?.attributedSecondaryText?.string
                            let suggestion = AutoCompleteSuggestion(title: primaryText ?? "", subtitle: secondaryText, coordinate: coordinate)
                            
                            if forUserLocation {
                                self.onCurrentLocationUpdate(suggestion)
                            } else {
                                self.onAddressUpdate(suggestion)
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

        private func shouldFetchNearbyPlaces(for coordinate: CLLocationCoordinate2D) -> Bool {
            guard let lastCoordinate = lastFetchedCoordinate else {
                return true // Always fetch for the first time
            }
            let currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let previousLocation = CLLocation(latitude: lastCoordinate.latitude, longitude: lastCoordinate.longitude)
            return currentLocation.distance(from: previousLocation) > coordinateThreshold
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let userLocation = locations.first else { return }
            fetchNearbyPlaceName(coordinate: userLocation.coordinate, forUserLocation: true)
            
            if shouldCenterOnUserLocation {
                centerUserLocation(userLocation.coordinate)
            }
            updateUserLocationMarker(coordinate: userLocation.coordinate)
        }
        
        private func centerUserLocation(_ coordinate: CLLocationCoordinate2D) {
            guard let mapView = mapView else { return }
            let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
                                                  longitude: coordinate.longitude,
                                                  zoom: 16)
            mapView.camera = camera
        }
        
        private func updateUserLocationMarker(coordinate: CLLocationCoordinate2D) {
            // Initialize the marker if it doesn't already exist
            if userLocationMarker == nil {
                userLocationMarker = GMSMarker()
                userLocationMarker?.icon = UIImage(named: "locationMarker", in: Bundle.module, with: nil)
                userLocationMarker?.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                userLocationMarker?.map = mapView
            }
            // Update the marker's position
            userLocationMarker?.position = coordinate
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse {
                locationManager.startUpdatingLocation()
                mapView?.isMyLocationEnabled = false // Disable default blue location circle
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
