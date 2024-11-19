//
//  RideSelectionTile.swift
//
//
//  Created by Aswin V Shaji on 26/10/24.
//

import SwiftUI
import SVGView

struct RideSelectionTile: View {
    @Environment(\.colorScheme) var colorScheme
    let rideOption: RideOption
    var isSelected: Bool
    
    private let isRideDetailView: Bool
    
    init(rideOption: RideOption,
         isSelected: Bool,
         isRideDetailView: Bool = false) {
        self.rideOption = rideOption
        self.isSelected = isSelected
        self.isRideDetailView = isRideDetailView
    }
    
    var body: some View {
        HStack {
//            SVGView(contentsOf: Bundle.main.url(forResource: "example", withExtension: "svg")!)
            SVGView(contentsOf: URL(string: rideOption.image ?? "")!)
                .frame(width: 50,height: 50)
                .scaledToFit()
//            AsyncImage(url: URL(string: rideOption.image ?? ""))
//                .frame(width: 60,height: 60)
//                .scaledToFit()
//            Image(isSelected ? "taxiSelected" : "taxiUnselected", bundle: Bundle.module)
//                .padding(8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(rideOption.name ?? "")
                    .font(.body)
                
                HStack {
                    Image("clockSecondary", bundle: Bundle.module)
                    Text("\((rideOption.estimation?.duration ?? 0) / 60) " + "min".localized())
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Image("userCircle", bundle: Bundle.module)
                    Text("\(rideOption.capacity ?? 0) " + "seats".localized())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            if !isRideDetailView {
                VStack{
                    Text("\(rideOption.estimation?.estimate ?? 0, specifier: "%.2f")")
                    Text("\( rideOption.estimation?.currencyCode ?? "")")
                        .font(.footnote)
                }
                
            }
        }
        .padding(isRideDetailView ? 0 : 8)
        .background(isRideDetailView ? nil : isSelected ? colorScheme == .dark ? nil : Color(hex: "#F2F7FF") : Color(.systemBackground))
        .cornerRadius(10)
        .overlay(isRideDetailView ? nil : 
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color(hex: "#663A80") : Color(hex: "#F1F5F9"), lineWidth: 1.5)
        )
        .padding(.horizontal)
    }
}

#Preview {
    RideSelectionTile(rideOption: RideOptionMockData, isSelected: true)
}
