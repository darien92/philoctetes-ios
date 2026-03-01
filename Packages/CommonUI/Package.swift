// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "CommonUI",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "CommonUI", targets: ["CommonUI"]),
    ],
    targets: [
        .target(name: "CommonUI"),
        .testTarget(
            name: "CommonUITests",
            dependencies: ["CommonUI"]
        ),
    ]
)
