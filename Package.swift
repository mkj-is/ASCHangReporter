// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ASCHangReporter",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "ASCHangReporter", targets: ["ASCHangReporter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(url: "https://github.com/AvdLee/appstoreconnect-swift-sdk.git", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
        .executableTarget(name: "ASCHangReporter", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            .product(name: "AppStoreConnect-Swift-SDK", package: "appstoreconnect-swift-sdk"),
        ]),
        .testTarget(name: "ASCHangReporterTests", dependencies: ["ASCHangReporter"]),
    ]
)
