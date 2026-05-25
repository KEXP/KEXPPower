// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KEXPPower",
    defaultLocalization: "en",
    platforms: [
        .iOS("26.0"),
    ],
    products: [
        .library(
            name: "KEXPPower",
            targets: ["KEXPPower"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "KEXPPower",
            dependencies: [
            ],
            path: "KEXPPower",
            resources: []
        ),
        .testTarget(
            name: "KEXPPowerTests",
            dependencies: ["KEXPPower"],
            path: "KEXPPowerTests",
            resources: [
                .process("Samples")
            ]
        ),
    ],
    swiftLanguageModes: [.v5]
)
