////
////  ConfirmLocationInMapSheet.swift
////  
////
////  Created by Aswin V Shaji on 26/10/24.
////

import SwiftUI

struct ConfirmLocationInMapSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: LocationSelectingViewModel
    var body: some View {
        VStack() {
            // Display total distance covered
            Spacer().frame(height: 20)
            Text("set_your_destination")
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
            Text("drag_the_map_to_move_the_pin")
                .font(.body)
                .fontWeight(.thin)
                .multilineTextAlignment(.leading)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color(hex: "#F1F5F9"))
                .padding(.top)
                .padding(.horizontal, 20)
            ZStack{
                Color(hex: colorScheme == .dark ? "#0A0A0A" : "#F8FAFC")
                HStack{
                    Image(systemName: "magnifyingglass")
                        .padding(.leading)
                    Text(viewModel.locationFromMap?.title ?? "")
                        .padding(5)
                    
                }
            }
            .frame(height: 40)
            .cornerRadius(50)
            .padding()
            
            LargeButton(
                title: "confirm_destination".localized(),
                backgroundColor: Color.white,
                foregroundColor: Color(hex: "#663A80")
            ) {
                if viewModel.forDestinationLocation {
                    viewModel.toLocation = viewModel.locationFromMap?.title ?? ""
                    viewModel.selectedToLocation = viewModel.locationFromMap
                } else {
                    viewModel.fromLocation = viewModel.locationFromMap?.title ?? ""
                    viewModel.selectedFromLocation = viewModel.locationFromMap
                }
                if !(viewModel.selectedFromLocation == nil) && !(viewModel.selectedToLocation == nil) {
                    viewModel.isRideSelectionViewShowing = true
                } else {
                    viewModel.isConfirmLocationOnMapShowing = false
                }
            }
            .padding(.bottom)
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding(.bottom, 20)
    }
}

#Preview {
    ConfirmLocationInMapSheet(viewModel: LocationSelectingViewModel())
}
