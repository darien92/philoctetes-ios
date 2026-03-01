// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "CommonDomain",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "CommonDomain", targets: ["CommonDomain"]),
    ],
    targets: [
        .target(name: "CommonDomain"),
        .testTarget(
            name: "CommonDomainTests",
            dependencies: ["CommonDomain"]
        ),
    ]
)
