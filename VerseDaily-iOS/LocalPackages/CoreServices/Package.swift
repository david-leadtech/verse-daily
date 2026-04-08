// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CoreServices",
    platforms: [
        .iOS(.v17),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "CoreServices",
            targets: ["CoreServices"]
        )
    ],
    dependencies: [
        .package(path: "../CoreModels"),
        .package(path: "../DesignSystem"),
        .package(path: "../CorePersistence")
    ],
    targets: [
        .target(
            name: "CoreServices",
            dependencies: [
                "CoreModels",
                "DesignSystem",
                "CorePersistence"
            ],
            path: "Sources/CoreServices"
        ),
        .testTarget(
            name: "CoreServicesTests",
            dependencies: ["CoreServices"],
            path: "Tests/CoreServicesTests"
        )
    ]
)
