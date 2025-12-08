// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ImageGridKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "ImageGridKit",
            targets: ["ImageGridKit"]
        )
    ],
    targets: [
        .target(
            name: "ImageGridKit",
            dependencies: []
        ),
        .testTarget(
            name: "ImageGridKitTests",
            dependencies: ["ImageGridKit"]
        )
    ]
)
