// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_window_close",
    platforms: [
        .macOS("10.14")
    ],
    products: [
        .library(name: "flutter-window-close", targets: ["flutter_window_close"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "flutter_window_close",
            dependencies: [],
            resources: [
               .process("Resources"),
            ]
        )
    ]
)
