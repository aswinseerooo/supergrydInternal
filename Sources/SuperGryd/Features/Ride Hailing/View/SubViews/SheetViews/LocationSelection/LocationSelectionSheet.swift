//
//  LocationSelectionSheet.swift
//
//
//  Created by Aswin V Shaji on 26/10/24.
//

import SwiftUI
import CoreLocation

struct LocationSelectionSheet: View {
    @ObservedObject var viewModel: LocationSelectingViewModel
    var body: some View {
        VStack(alignment: .leading,spacing: 12) {
            // Display total distance covered
            Text("where_are_you_going_today")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .padding(.top,20)
                .padding(.horizontal)
            HStack {
                Image("stepper",bundle: Bundle.module)
                    .padding(.vertical)
                    .padding(.leading)
                    .padding(.trailing,5)
                VStack(alignment: .leading,spacing: 12) {
                    Text("pick_up")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(viewModel.fromLocation.isEmpty ? "where_from".localized() : viewModel.fromLocation)
                        .font(viewModel.fromLocation.isEmpty ? nil : .headline)
                        .fontWeight(viewModel.fromLocation.isEmpty ? nil : .semibold)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .onTapGesture {
                            viewModel.forDestinationLocation = false
                            viewModel.isLocationExpandedViewShowing = true
                        }
                    
                    Divider()
                    
                    Text("drop_off")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(viewModel.toLocation.isEmpty ? "where_to".localized() : viewModel.toLocation)
                        .font(viewModel.toLocation.isEmpty ? nil : .headline)
                        .fontWeight(viewModel.toLocation.isEmpty ? nil : .semibold)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .onTapGesture {
                            viewModel.forDestinationLocation = true
                            viewModel.isLocationExpandedViewShowing = true
                        }
                }
            }
            .padding(.trailing)
            
            Text("recent_places")
                .font(.headline)
                .padding(.horizontal)
            VStack(alignment: .leading,spacing: 10) {
                RecentPlacesTile(viewModel: viewModel, location: AutoCompleteSuggestion(title: "Christofstraße 20", subtitle: "72127 Berlin, Germany", coordinate: CLLocationCoordinate2D(latitude: 10.064588, longitude: 76.351151)))
                RecentPlacesTile(viewModel: viewModel, location: AutoCompleteSuggestion(title: "Sonnenweg 32", subtitle: "79669 Berlin, Germany",coordinate: CLLocationCoordinate2D(latitude: 10.064588, longitude: 76.351151)))
                RecentPlacesTile(viewModel: viewModel, location: AutoCompleteSuggestion(title: "Some Other Place", subtitle: "Some Other Country", coordinate: CLLocationCoordinate2D(latitude: 10.064588, longitude: 76.351151)))
            }
            .padding(.trailing)
            .padding(.bottom,20)
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding(.bottom, 20)
    }
}

#Preview {
    LocationSelectionSheet(viewModel: LocationSelectingViewModel())
        .environment(\.locale, .init(identifier: "de"))
    
}
