//
//  RideCompletedSheetView.swift
//
//
//  Created by Aswin V Shaji on 03/11/24.
//

import SwiftUI

struct RideCompletedSheetView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var fromLocation = "Sonnenweg 32, 79669 Berlin, Germany"
    @State private var toLocation = "St.-Martin-Straße 14, 93099 Berlin,Germany"
    @Binding var navigationPath: [String]
    var body: some View {
        ScrollView{
        VStack() {
            Image("SuccessIcon", bundle: Bundle.module)
                .padding(.top,30)
            Text("ride_completed")
                .font(.title3)
                .fontWeight(.bold)
                .padding(8)
            Text("ID123456789")
                .font(.headline)
                .foregroundStyle(Color(hex: "#663A80"))
                .padding(.bottom)
            Divider()
                .padding(.horizontal, 20)
            RideInfoItemView(distance: "21 km", time: "07:48AM",date: "28 Nov 2024",isRideCompletedView: true)
                .padding(.horizontal,20)
                .padding(.vertical,5)
            Divider()
                .padding(.horizontal, 20)
            PickupDropoffStepperView(fromLocation: $fromLocation, toLocation: $toLocation)
            HStack{
                HStack{
                    Image("profile", bundle: Bundle.module)
                        .resizable()
                        .frame(width: 50,height: 50)
                    VStack(alignment: .leading){
                        Text("Henry")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        Text("KA15AAC21-00")
                            .font(.footnote)
                            .fontWeight(.light)
                        Text("White Suzuki")
                            .font(.footnote)
                            .fontWeight(.light)
                    }
                    .padding(.leading,8)
                }
                Spacer()
                HStack() {
                    VStack(alignment: .leading){
                        Text("your_trip_fare")
                            .font(.footnote)
                            .fontWeight(.light)
                        Text("payment_option")
                            .font(.footnote)
                            .fontWeight(.light)
                    }
                    VStack(alignment: .leading){
                        Text("$8.00")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        Text("cash")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding(.horizontal,20)
            HStack{
                LargeButton(
                    title: "booking_history".localized(),
                    backgroundColor: Color.white,
                    foregroundColor: Color(hex: "#6C7B88"),
                    buttonHorizontalMargins: 0,
                    cornerRadius: 8
                ) {
                    
                }
                Spacer()
                LargeButton(
                    title: "rate_this_ride".localized(),
                    backgroundColor: Color.white,
                    foregroundColor: Color(hex: "#6C7B88"),
                    buttonHorizontalMargins: 0,
                    cornerRadius: 8
                ) {
                    navigationPath.append("RateDriverView")
                }
            }
            .padding(.horizontal,20)
            Image("SeparatorDotted", bundle: Bundle.module)
                .resizable()
                .padding(.horizontal,20)
                .padding(.vertical,8)
            HStack {
                Text("recommended_services")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal,20)
            Image("recommendedService", bundle: Bundle.module)
                .resizable()
                .frame(height: 150)
                .padding(.bottom, 20)
                .padding(.horizontal,20)
            Button{
                navigationPath = []
            }label: {
                Text("close")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
            }
            .padding(.bottom, 20)
        }
        .frame(width: UIScreen.main.bounds.width - 35)
    }
        .scrollIndicators(.hidden)
        .frame(width: UIScreen.main.bounds.width - 35)
            .background(Color(.systemBackground))
            .cornerRadius(20)
    }
}

#Preview {
    RideCompletedSheetView(navigationPath: .constant([]))
}
