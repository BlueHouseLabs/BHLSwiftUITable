// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BHLSwiftUITable",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "BHLSwiftUITableModel",
            targets: ["BHLSwiftUITableModel"]
        ),
        .library(
            name: "BHLSwiftUITable",
            targets: ["BHLSwiftUITable"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/BlueHouseLabs/BHLSwiftHelpers.git", from: "0.2.0"),
        .package(url: "https://github.com/BlueHouseLabs/BHLSwiftUIHelpers.git", from: "0.2.1"),
    ],
    targets: [
        
        .target(
            name: "BHLSwiftUITableModel",
            dependencies: [
                .product(name: "BHLSwiftHelpers", package: "BHLSwiftHelpers"),
                .product(name: "BHLSwiftUIHelpers", package: "BHLSwiftUIHelpers"),
            ]
        ),
        .testTarget(
            name: "BHLSwiftUITableModelTests",
            dependencies: ["BHLSwiftUITableModel"]
        ),
        .target(
            name: "BHLSwiftUITable",
            dependencies: [
                "BHLSwiftUITableModel",
                .product(name: "BHLSwiftHelpers", package: "BHLSwiftHelpers"),
                .product(name: "BHLSwiftUIHelpers", package: "BHLSwiftUIHelpers"),
            ]
        ),
        .testTarget(
            name: "BHLSwiftUITableTests",
            dependencies: ["BHLSwiftUITable"]
        ),
    ]
)
