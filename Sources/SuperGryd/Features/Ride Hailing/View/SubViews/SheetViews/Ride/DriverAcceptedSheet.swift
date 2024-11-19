//
//  DriverAcceptedSheet.swift
//
//
//  Created by Aswin V Shaji on 31/10/24.
//

import SwiftUI

struct DriverAcceptedSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isCancelClicked: Bool
    @Binding var isDriverPickedUp: Bool
    let tripInfo: TripInfoModel
    let driverInfo: DriverInfoModel
    @Binding var title: String
    var body: some View {
        VStack() {
            // Display total distance covered
            Rectangle()
                .frame(width: 50,height: 5)
                .foregroundStyle(Color(hex: "#F1F5F9"))
                .padding()
            if !isDriverPickedUp {
                Text(title)
                   .font(.title3)
                   .fontWeight(.bold)
               Divider()
                   .padding(.horizontal, 20)
                   .padding(.vertical,8)
            }
            HStack{
                if isDriverPickedUp {
                    Text("ongoing_ride")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                    Text("5_min_away_from_destination")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }else{
                    Text("pin_for_this_trip")
                        .font(.subheadline)
                    Spacer()
                    ForEach(tripInfo.tripPin, id: \.self) { pinDigit in
                        Rectangle()
                            .foregroundStyle(Color(hex: "#663A80"))
                            .frame(width: 30, height: 35)
                            .overlay(Text("\(pinDigit)").foregroundStyle(.white))
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 5)
                    }
                }
            }
            .padding(.horizontal,20)
            Divider()
                .padding(.horizontal, 20)
                .padding(.vertical,8)
            HStack() {
                ZStack(alignment: .bottom){
                    Image(driverInfo.vehicleImage,bundle: Bundle.module)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100,alignment: .bottom)
                        .offset(x:65)
                    
                    Image(driverInfo.driverImage,bundle: Bundle.module)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
                Spacer()
                VStack(alignment: .trailing){
                    Text(driverInfo.driverName)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    Text(driverInfo.vehicleNumber)
                        .font(.headline)
                        .lineLimit(1)
                        .padding(.bottom,2)
                    Text(driverInfo.vehicleDescription)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
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
                if !isDriverPickedUp {
//                    Image("Message", bundle: Bundle.module)
                    Image("Call", bundle: Bundle.module)
                        .padding(.leading)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding(.bottom, 20)
    }
}

#Preview {
    DriverAcceptedSheet(isCancelClicked: .constant(false), isDriverPickedUp: .constant(false), tripInfo: tripInfoMockData, driverInfo: driverInfoMockData, title: .constant("pick_up_in_6_min".localized()))
}
