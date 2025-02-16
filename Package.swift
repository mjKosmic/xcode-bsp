// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XcodeBSP",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/ChimeHQ/LanguageServerProtocol", from: "0.9.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
        .package(url: "https://github.com/MobileNativeFoundation/XCLogParser", from: "0.2.0"),
        .package(url: "https://github.com/tuist/XcodeProj", from: "8.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "XcodeBSP",
            dependencies: [
                .product(name: "LanguageServerProtocol", package: "LanguageServerProtocol"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "XCLogParser", package: "XCLogParser"),
                .product(name: "XcodeProj", package: "XcodeProj")
            ]
        )
    ]
)
