// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CoreUtils",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "CoreUtils",
            targets: ["CoreUtils"]
        )
    ],
    targets: [
        .target(
            name: "CoreUtils",
            path: "Sources/CoreUtils"
        ),
        .testTarget(
            name: "CoreUtilsTests",
            dependencies: ["CoreUtils"],
            path: "Tests/CoreUtilsTests"
        )
    ]
)
