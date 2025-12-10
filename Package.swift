// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ArtFrameRayTracer",
    products: [
        .library(
            name: "ArtFrameCore",
            targets: ["ArtFrameCore"]
        ),
        .library(
            name: "ArtFrameRayTracer",
            targets: ["ArtFrameRayTracer"]
        ),
    ],
    targets: [
        .target(
            name: "ArtFrameCore",
            path: "Sources/ArtFrameCore"
        ),
        .target(
            name: "ArtFrameRayTracer",
            dependencies: ["ArtFrameCore"],
            path: "Sources/ArtFrameRayTracer"
        ),
        .testTarget(
            name: "ArtFrameRayTracerTests",
            dependencies: ["ArtFrameRayTracer"]
        ),
    ]
)
