// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "CommonNetwork",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "CommonNetwork", targets: ["CommonNetwork"]),
    ],
    targets: [
        .target(name: "CommonNetwork"),
        .testTarget(
            name: "CommonNetworkTests",
            dependencies: ["CommonNetwork"]
        ),
    ]
)
