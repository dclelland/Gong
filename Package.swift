// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Gong",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_10),
        .tvOS(.v9)
    ],
    products: [
        .library(
            name: "Gong",
            targets: ["Gong"])
    ],
    targets: [
        .target(name: "Gong", dependencies: [])
    ]
)
