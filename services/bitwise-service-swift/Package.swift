// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "BitwiseService",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.75.0"),
    ],
    targets: [
        .target(
            name: "BitwiseService",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
            ],
            path: "Sources/BitwiseService"
        ),
        .testTarget(
            name: "BitwiseServiceTests",
            dependencies: ["BitwiseService"]
        )
    ]
)