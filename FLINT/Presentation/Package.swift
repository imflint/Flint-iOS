// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Presentation",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Presentation",
            targets: ["Presentation"]
        ),
    ],
    
    dependencies: [
        .package(name: "Domain", path: "../Domain"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", "0.0.0"..."8.6.2"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", "0.0.0"..."5.7.1"),
        .package(url: "https://github.com/devxoul/Then.git", "0.0.0"..."3.0.0"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", "0.0.0"..."4.5.2"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk.git", "0.0.0"..."2.27.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "Presentation", dependencies: [
            "ViewModel",
            "View",
            "ViewController",
        ]),
        .target(name: "ViewModel", dependencies: [
            .product(name: "Domain", package: "Domain"),
            .product(name: "KakaoSDK", package: "kakao-ios-sdk"),
        ]),
        .target(
            name: "View",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "Then", package: "Then"),
                .product(name: "Lottie", package: "lottie-ios"),
            ],
            resources: [
                .process("Resource"),
            ]
        ),
        .target(name: "ViewController", dependencies: [
            "ViewModel",
            "View",
            .product(name: "Kingfisher", package: "Kingfisher"),
        ]),
    ]
)
