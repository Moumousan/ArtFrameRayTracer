// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.


// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "ArtFrameRayTracer",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "ArtFrameRayTracer",
            targets: ["ArtFrameRayTracer"]
        )
    ],
    targets: [
        // 共通型・セッション・protocol
        .target(
            name: "ArtFrameCore",
            path: "Sources/ArtFrameCore"
        ),

        // CPU レンダラー
        .target(
            name: "ArtFrameRayTracerCPU",
            dependencies: ["ArtFrameCore"],
            path: "Sources/ArtFrameRayTracerCPU"
        ),

        // Metal レンダラー（中身はあとで）
        .target(
            name: "ArtFrameRayTracerMetal",
            dependencies: ["ArtFrameCore"],
            path: "Sources/ArtFrameRayTracerMetal"
            // resources: [.process("Shaders")] などは後で
        ),

        // 公開 Facade
        .target(
            name: "ArtFrameRayTracer",
            dependencies: [
                "ArtFrameCore",
                "ArtFrameRayTracerCPU",
                "ArtFrameRayTracerMetal"
            ],
            path: "Sources/ArtFrameRayTracer"
        ),

        .testTarget(
            name: "ArtFrameRayTracerTests",
            dependencies: ["ArtFrameRayTracer"]
        )
    ]
)
