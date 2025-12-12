// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TransLinka",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TransLinka",
            targets: ["TransLinka"]),
    ],
    dependencies: [
        // Add blockchain dependencies here
        // .package(url: "https://github.com/argentlabs/web3.swift", from: "1.0.0"),
        // .package(url: "https://github.com/p2p-org/solana-swift", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "TransLinka",
            dependencies: [],
            path: "TransLinka"
        ),
        .testTarget(
            name: "TransLinkaTests",
            dependencies: ["TransLinka"],
            path: "TransLinkaTests"
        ),
    ]
)

