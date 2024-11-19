//
//  RideOptionsModel.swift
//
//
//  Created by Aswin V Shaji on 29/10/24.
//

struct RideOptionsModel {
    let name: String
    let expectedArrivalTime: String
    let numberOfSeats: Int
    let price: String
}

let rideOptionsMockData = [
    RideOptionsModel(name: "Normal", expectedArrivalTime: "2 min", numberOfSeats: 2, price: "$8.00"),
    RideOptionsModel(name: "Premium", expectedArrivalTime: "5 min", numberOfSeats: 3, price: "$12.00"),
    RideOptionsModel(name: "Luxury", expectedArrivalTime: "7 min", numberOfSeats: 4, price: "$20.00")
]
