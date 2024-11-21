//
//  RideTrackingMapView.swift
//
//
//  Created by Aswin V Shaji on 21/11/24.
//

import SwiftUI
import GoogleMaps
import Combine

struct RideTrackingMapView: UIViewRepresentable {
    @ObservedObject var rideViewModel: RideViewModel
    func makeUIView(context: Context) -> GMSMapView {
        let startCoordinate = rideViewModel.initialDriverLocation ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        let endCoordinate = rideViewModel.fromLocation ?? CLLocationCoordinate2D(latitude: 10.064588, longitude: 76.351151)

        let camera = GMSCameraPosition.camera(withLatitude: startCoordinate.latitude, longitude: startCoordinate.longitude, zoom: 15.0)
        let mapView = GMSMapView(frame: .zero)
        mapView.camera = camera

        // End marker
        let endMarker = GMSMarker(position: endCoordinate)
        endMarker.title = "End Point"
        endMarker.snippet = "Seeroo IT Solutions"
        endMarker.map = mapView
        context.coordinator.endMarker = endMarker

        // Driver marker
        context.coordinator.driverMarker.map = mapView

        // Draw initial route
        context.coordinator.drawRoute(from: startCoordinate, to: endCoordinate, on: mapView)

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        guard let driverLocation = rideViewModel.currentDriverLocation else { return }

        // Update driver's marker position
        context.coordinator.updateDriverMarker(to: driverLocation, on: uiView)

        // Determine the destination based on the rideStatus
        let endCoordinate: CLLocationCoordinate2D
        if rideViewModel.rideTrackingResponse?.rideStatus ?? 0 >= 4 {
            // If rideStatus is 4, use the final destination
            endCoordinate = rideViewModel.toLocation ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)

            // Remove the old marker (if any)
            if let oldMarker = context.coordinator.endMarker {
                oldMarker.map = nil // Remove marker from the map
                context.coordinator.endMarker = nil
            }

            // Add a new marker for the final destination
            let finalMarker = GMSMarker(position: endCoordinate)
            finalMarker.title = "Final Destination"
            finalMarker.snippet = "To Location"
            finalMarker.map = uiView
            context.coordinator.endMarker = finalMarker
        } else {
            // Use the initial end location
            endCoordinate = rideViewModel.fromLocation ?? CLLocationCoordinate2D(latitude: 10.064588, longitude: 76.351151)
        }

        // Redraw the route from the driver's location to the determined end location
        context.coordinator.drawRoute(from: driverLocation, to: endCoordinate, on: uiView)
    }


    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var driverMarker: GMSMarker = {
            let marker = GMSMarker()
            marker.icon = UIImage(named: "carMap", in: Bundle.module, with: nil) // Provide your car icon image
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            marker.isFlat = true
            return marker
        }()
        var endMarker: GMSMarker?
        var routePolyline: GMSPolyline?

        func updateDriverMarker(to location: CLLocationCoordinate2D, on mapView: GMSMapView) {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)
            driverMarker.position = location
            mapView.animate(toLocation: location) // Optionally move the camera
            CATransaction.commit()
        }

        
        func drawRoute(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D, on mapView: GMSMapView) {
            let origin = "\(start.latitude),\(start.longitude)"
            let destination = "\(end.latitude),\(end.longitude)"
            let apiKey = "AIzaSyA_VcC8o95gW_Fo5efpVkMJCtn4DV4CsYg"
            let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=\(apiKey)"

            guard let url = URL(string: urlString) else { return }

            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching route data: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let routes = json["routes"] as? [[String: Any]],
                       let overviewPolyline = routes.first?["overview_polyline"] as? [String: Any],
                       let points = overviewPolyline["points"] as? String {
                        // Decode polyline
                        guard let path = GMSMutablePath(fromEncodedPath: points) else {
                            print("Failed to decode polyline")
                            return
                        }

                        DispatchQueue.main.async {
                            // Remove the previous polyline if present
                            self.routePolyline?.map = nil

                            // Draw the new route
                            let polyline = GMSPolyline(path: path)
                            polyline.strokeColor = .blue // Route is always blue
                            polyline.strokeWidth = 4.0
                            polyline.map = mapView

                            // Store the new polyline for future reference
                            self.routePolyline = polyline
                        }
                    } else {
                        print("Invalid JSON format or missing route data")
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
        }

        func isLocation(_ location: CLLocationCoordinate2D, nearPath path: GMSPath, threshold: Double) -> Bool {
            for i in 0..<path.count() - 1 {
                let segmentStart = path.coordinate(at: i)
                let segmentEnd = path.coordinate(at: i + 1)

                if distanceFrom(location, toSegmentStart: segmentStart, toSegmentEnd: segmentEnd) <= threshold {
                    return true
                }
            }
            return false
        }

        func distanceFrom(_ location: CLLocationCoordinate2D, toSegmentStart start: CLLocationCoordinate2D, toSegmentEnd end: CLLocationCoordinate2D) -> Double {
            let loc = CLLocation(latitude: location.latitude, longitude: location.longitude)
            let startLoc = CLLocation(latitude: start.latitude, longitude: start.longitude)
            let endLoc = CLLocation(latitude: end.latitude, longitude: end.longitude)

            // Project the point onto the line segment
            let A = startLoc.coordinate.latitude
            let B = startLoc.coordinate.longitude
            let C = endLoc.coordinate.latitude
            let D = endLoc.coordinate.longitude
            let E = location.latitude
            let F = location.longitude

            let AB = (C - A, D - B)
            let AP = (E - A, F - B)

            let dotProduct = AB.0 * AP.0 + AB.1 * AP.1
            let lenSquared = AB.0 * AB.0 + AB.1 * AB.1
            let t = max(0, min(1, dotProduct / lenSquared))

            let closestPoint = CLLocationCoordinate2D(
                latitude: A + t * AB.0,
                longitude: B + t * AB.1
            )
            return loc.distance(from: CLLocation(latitude: closestPoint.latitude, longitude: closestPoint.longitude))
        }
    }
}
