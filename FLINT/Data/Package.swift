// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Data",
            targets: ["Data"]
        ),
    ],
    dependencies: [
        .package(name: "Domain", path: "../Domain"),
        .package(url: "https://github.com/Moya/Moya.git", "0.0.0"..."15.0.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "Data", dependencies: [
            "DTO",
            "Networking",
            "RepositoryImpl",
        ]),
        .target(name: "DTO", dependencies: [
            .product(name: "Domain", package: "Domain"),
        ]),
        .target(
            name: "Networking",
            dependencies: [
                "DTO",
                .product(name: "Moya", package: "Moya"),
                .product(name: "CombineMoya", package: "Moya"),
            ],
            resources: [
                .process("Flint-iOS-Private"),
            ]
        ),
        .target(name: "RepositoryImpl", dependencies: [
            "Networking",
        ]),
    ]
)
