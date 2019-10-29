// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Gong",
    products: [
        .library(
            name: "Gong",
            targets: ["Gong"]
        )
    ],
    targets: [
        .target(
            name: "Gong",
            path: "Sources"
        )
    ]
)
