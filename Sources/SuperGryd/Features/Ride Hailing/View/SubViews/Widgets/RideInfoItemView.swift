//
//  RideInfoItemView.swift
//
//
//  Created by Aswin V Shaji on 31/10/24.
//

import SwiftUI

struct RideInfoItemView: View {
    let distance: String 
    let time: String
    let date: String
    let price: String
    let isRideCompletedView: Bool
    init(
        distance: String,
        time: String,
        date: String = "",
        price: String = "",
        isRideCompletedView: Bool = false
    ) {
        self.distance = distance
        self.time = time
        self.date = date
        self.price = price
        self.isRideCompletedView = isRideCompletedView
    }
    var body: some View {
        HStack{
            isRideCompletedView && !date.isEmpty ? RideInfoSingleItemView(imageName: "CalendarIcon", text: date) :
            RideInfoSingleItemView(imageName: "distanceCircle", text: distance)
            Spacer()
            RideInfoSingleItemView(imageName: "clock", text: time)
            Spacer()
            isRideCompletedView ? RideInfoSingleItemView(imageName: "distanceCircle", text: distance) :
            RideInfoSingleItemView(imageName: "dollarCircle", text: price)
        }
    }
}
#Preview {
    RideInfoItemView(distance: "", time: "")
}
