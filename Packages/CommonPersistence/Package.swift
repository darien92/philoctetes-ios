// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "CommonPersistence",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "CommonPersistence", targets: ["CommonPersistence"]),
    ],
    targets: [
        .target(name: "CommonPersistence"),
        .testTarget(
            name: "CommonPersistenceTests",
            dependencies: ["CommonPersistence"]
        ),
    ]
)
