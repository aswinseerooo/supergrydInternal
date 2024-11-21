//
//  RideInfoItemView.swift
//
//
//  Created by Aswin V Shaji on 31/10/24.
//

import SwiftUI

struct RideInfoItemView: View {
    let distance: Text
    let time: Text
    let date: Text
    let price: Text
    let isRideCompletedView: Bool
    init(
        distance: Text,
        time: Text,
        date: Text = Text(""),
        price: Text = Text(""),
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
            isRideCompletedView && !(date == Text("")) ? RideInfoSingleItemView(imageName: "CalendarIcon", text: date) :
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
    RideInfoItemView(distance: Text(""), time: Text(""))
}
