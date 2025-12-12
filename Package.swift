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
        // Ethereum (web3) + BigInt
        .package(url: "https://github.com/argentlabs/web3.swift", from: "0.9.3"),
        .package(url: "https://github.com/attaswift/BigInt", from: "5.3.0"),
        // Solana example (uncomment when wiring the Solana integration)
        // .package(url: "https://github.com/p2p-org/solana-swift", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "TransLinka",
            dependencies: [
                .product(name: "Web3", package: "web3.swift"),
                .product(name: "BigInt", package: "BigInt"),
            ],
            path: "TransLinka"
        ),
        .testTarget(
            name: "TransLinkaTests",
            dependencies: ["TransLinka"],
            path: "TransLinkaTests"
        ),
    ]
)

