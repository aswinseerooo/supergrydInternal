
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SuperGryd",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "SuperGryd",targets: ["SuperGryd"]),
    ],
    dependencies: [
        // Add dependencies here if needed
        .package(
            url: "https://github.com/googlemaps/ios-maps-sdk",
            from: "9.1.1" // The latest version at the time
        ),
        .package(
            url: "https://github.com/googlemaps/ios-places-sdk",
            from: "9.1.0"
        ),
        .package(
            url: "https://github.com/lucaszischka/BottomSheet",
            from: "3.1.1"
        ),
        .package(
            url: "https://github.com/Alamofire/Alamofire.git",
            from: "5.10.1"
        ),
        .package(
            url: "https://github.com/exyte/SVGView",
            from: "1.0.6"
        )
    ],
    targets: [
        .target(
            name: "SuperGryd",
            dependencies: [
                .product(name: "GoogleMaps", package: "ios-maps-sdk"),
                .product(name: "GooglePlaces", package: "ios-places-sdk"),
                .product(name: "BottomSheet", package: "BottomSheet"),
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "SVGView", package: "SVGView")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "SuperGrydTests",
            dependencies: ["SuperGryd"]
        ),
    ]
)
