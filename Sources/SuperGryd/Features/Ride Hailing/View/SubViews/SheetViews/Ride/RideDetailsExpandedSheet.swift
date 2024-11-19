//
//  RideDetailsExpandedSheet.swift
//
//
//  Created by Aswin V Shaji on 31/10/24.
//

import SwiftUI

struct RideDetailsExpandedSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var rating: Int = 4
    @Binding var isCancelClicked: Bool
    private let maxRating = 5
    private let unselectedImage = Image("ratingUnselected", bundle: Bundle.module)
    private let selectedImage = Image("ratingSelected", bundle: Bundle.module)
    let tripInfo: TripInfoModel
    let driverInfo: DriverInfoModel
    
    var body: some View {
        VStack{
            Rectangle()
                .frame(width: 50,height: 5)
                .foregroundStyle(Color(hex: "#F1F5F9"))
                .padding()
            VStack(alignment: .leading) {
                // Display total distance covered
                
                Text("ride_details")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)
                
                HStack() {
                    Image(driverInfo.driverImage,bundle: Bundle.module)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading){
                        Text(driverInfo.driverName)
                            .font(.headline)
                            .lineLimit(1)
                            .padding(.bottom,1)
                        Text("experience".localized() + ": " + "1 yr")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .padding(.bottom,2)
                        Text("total_rides".localized() + ": " + "1000")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                        HStack(spacing: 8) {
                            ForEach(1...maxRating, id: \.self) { starIndex in
                                (starIndex <= rating ? selectedImage : unselectedImage)
                                    .resizable()
                                    .frame(width: 10, height: 10)
                            }
                            Text("\(rating).0")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal,8)
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal,20)
                Divider()
                    .padding(.horizontal, 20)
                    .padding(.bottom,8)
                RideInfoItemView(distance: "21 km", time: "8 min", price: "$8.00")
                    .padding(.horizontal, 40)
                Divider()
                    .padding(.horizontal, 20)
                    .padding(.top,8)
//                RideSelectionTile(
//                    rideOption: rideOptionsMockData[0],
//                    isSelected: true,
//                    isRideDetailView: true
//                )
                Divider()
                    .padding(.horizontal, 20)
                PickupDropoffStepperView(fromLocation: .constant("Sonnenweg 32, 79669 Berlin, Germany"), toLocation: .constant("St.-Martin-Straße 14, 93099 Berlin,Germany"))
                Divider()
                    .padding(.horizontal, 20)
                    .padding(.bottom,8)
                HStack{
                    VStack(alignment: .leading){
                        Text("payment_method")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        Text("total_price")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .padding(.vertical,2)
                    }
                    Spacer()
                    VStack(alignment: .trailing){
                        Text("cash")
                            .font(.callout)
                        Text("$8.00")
                            .font(.callout)
                            .padding(.vertical,2)
                    }
                }
                .padding(.horizontal,20)
                Divider()
                    .padding(.horizontal, 20)
                    .padding(.vertical,8)
                HStack{
                    LargeButton(
                        title: "cancel".localized(),
                        backgroundColor: Color.white,
                        foregroundColor: Color(hex: "#663A80"),
                        buttonHorizontalMargins: 0
                    ) {
                        isCancelClicked = true
                    }
//                    Image("Message", bundle: Bundle.module)
                    Image("Call", bundle: Bundle.module)
                        .padding(.leading)
                }
                .padding(.horizontal)
                .padding(.bottom)
                
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding(.bottom, 20)
    }
}

#Preview {
    RideDetailsExpandedSheet(isCancelClicked: .constant(false), tripInfo: tripInfoMockData, driverInfo: driverInfoMockData)
}
