// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MonetizationServices",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "MonetizationServices",
            targets: ["MonetizationServices"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/RevenueCat/purchases-ios-spm.git", from: "4.0.0"),
        .package(path: "../CoreModels"),
        .package(path: "../DesignSystem")
    ],
    targets: [
        .target(
            name: "MonetizationServices",
            dependencies: [
                .product(name: "RevenueCat", package: "purchases-ios-spm"),
                .product(name: "CoreModels", package: "CoreModels"),
                .product(name: "DesignSystem", package: "DesignSystem")
            ],
            path: "Sources/MonetizationServices"
        ),
        .testTarget(
            name: "MonetizationServicesTests",
            dependencies: ["MonetizationServices"],
            path: "Tests/MonetizationServicesTests"
        )
    ]
)
