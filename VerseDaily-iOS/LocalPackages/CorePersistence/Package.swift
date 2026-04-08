// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CorePersistence",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "CorePersistence",
            targets: ["CorePersistence"]
        )
    ],
    dependencies: [
        .package(path: "../CoreModels")
    ],
    targets: [
        .target(
            name: "CorePersistence",
            dependencies: [
                "CoreModels"
            ],
            path: "Sources/CorePersistence"
        ),
        .testTarget(
            name: "CorePersistenceTests",
            dependencies: ["CorePersistence"],
            path: "Tests/CorePersistenceTests"
        )
    ]
)
