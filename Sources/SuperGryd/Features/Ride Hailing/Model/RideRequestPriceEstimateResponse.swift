//
//  RideRequestPriceEstimateResponse.swift
//
//
//  Created by Aswin V Shaji on 12/11/24.
//

// MARK: - RideRequestPriceEstimateResponse

struct RideRequestPriceEstimateResponse: Codable {
    let status: Int?
    let message: String?
    let data: [RideOption]?
}

struct RideOption: Codable {
    let id: String?
    let name: String?
    let capacity: Int?
    let displayName: String?  // Make optional
    let shortDescription: String?
    let description: String?
    let image: String?
    let mappingProducts: [MappingProduct]?
    let estimation: Estimation?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, capacity, displayName = "display_name"
        case shortDescription = "short_description"
        case description, image, mappingProducts = "mapping_products"
        case estimation
    }
}

struct MappingProduct: Codable {
    let serviceProvider: String
    let productID: String
    let productName: String
    
    enum CodingKeys: String, CodingKey {
        case serviceProvider = "service_provider"
        case productID = "product_id"
        case productName = "product_name"
    }
}

struct Estimation: Codable {
    let localizedDisplayName: String?
    let displayName: String?
    let productID: String?
    let distance: Double?
    let highEstimate: Double?
    let lowEstimate: Double?
    let duration: Int?
    let fareID: Int?
    let estimate: Double?
    let currencyCode: String?
    
    enum CodingKeys: String, CodingKey {
        case localizedDisplayName = "localized_display_name"
        case displayName = "display_name"
        case productID = "product_id"
        case distance
        case highEstimate = "high_estimate"
        case lowEstimate = "low_estimate"
        case duration
        case fareID = "fare_id"
        case estimate
        case currencyCode = "currency_code"
    }
}

var MappingProductMockData = [
    MappingProduct(
        serviceProvider: "6667ee14f4ef66615afa1186",
        productID: "uber-go-a1111c8c-c720-46c3-8534-2fcdd730040d",
        productName: ""
    )
]
var EstimationMockData = Estimation(
    localizedDisplayName: "Uber Go",
    displayName: "Uber Go",
    productID: "uber-go-a1111c8c-c720-46c3-8534-2fcdd730040d",
    distance: 3.36,
    highEstimate: nil,
    lowEstimate: nil,
    duration: 202,
    fareID: 8743,
    estimate: 145.57,
    currencyCode: "INR"
)
var RideOptionMockData =
    RideOption(
        id: "666569ff8e0cfcd234f83469",
        name: "Normal",
        capacity: 4,
        displayName: "Normal",
        shortDescription: "Normal is the budget economy ride",
        description: "Normal is the budget economy ride",
        image: "https://supergryd-files.s3.ap-south-1.amazonaws.com/raide-hail/product/logo/8d5e4dd2-0bfa-49b8-9439-1db7f19de317-Group.svg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA2UC3DT7G2FZCZCWA%2F20241112%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Date=20241112T041737Z&X-Amz-Expires=5000&X-Amz-Signature=e223b69706674fea5317fe33f6fbcd9d7ac8431689b94321ae442342934665bc&X-Amz-SignedHeaders=host",
        mappingProducts: MappingProductMockData,
        estimation: EstimationMockData
    )

var RideRequestPriceEstimateMockData = RideRequestPriceEstimateResponse(
    status: 200,
    message: "Success.",
    data: [RideOptionMockData]
)

     
