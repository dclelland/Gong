// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Gong",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_15),
        .tvOS(.v9)
    ],
    products: [
        .library(name: "Gong", targets: ["Gong"])
    ],
    targets: [
        .target(name: "Gong", dependencies: [])
    ]
)
