//
//  RecentPlacesTile.swift
//
//
//  Created by Aswin V Shaji on 26/10/24.
//

import SwiftUI

struct RecentPlacesTile: View {
    @ObservedObject var viewModel: LocationSelectingViewModel
    var location: AutoCompleteSuggestion
    
    var body: some View {
        HStack {
            Image("locationIcon",bundle: Bundle.module)
                .padding(.leading,15)
                .padding(.trailing, 5)
            
            VStack(alignment: .leading) {
                Text(location.title)
                    .lineLimit(1)
                Text(location.subtitle ?? "Office")
                    .lineLimit(1)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .onTapGesture {
            // Update the toLocation when this tile is tapped
            viewModel.isLocationExpandedViewShowing = false
            
            if viewModel.forDestinationLocation {
                viewModel.toLocation = location.title
                viewModel.selectedToLocation = location
            } else {
                viewModel.fromLocation = location.title
                viewModel.selectedFromLocation = location
            }
            
            if !(viewModel.selectedFromLocation == nil) && !(viewModel.selectedToLocation == nil) {
                viewModel.isRideSelectionViewShowing = true
            }else{
                viewModel.isRideSelectionViewShowing = false
            }
            
        }
    }
}

#Preview {
    RecentPlacesTile(viewModel: LocationSelectingViewModel(), location: AutoCompleteSuggestion(title: "", subtitle: ""))
}
