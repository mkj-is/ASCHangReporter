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
        .package(name: "ArgumentParser", url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(name: "ASCHangReporter", dependencies: [
            .product(name: "ArgumentParser", package: "ArgumentParser"),
        ]),
        .testTarget(
            name: "ASCHangReporterTests",
            dependencies: ["ASCHangReporter"]),
    ]
)
