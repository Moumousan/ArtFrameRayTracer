// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

<<<<<<< HEAD

// swift-tools-version: 6.2
=======
>>>>>>> f9b290d (Initial ArtFrameRayTracer)
import PackageDescription

let package = Package(
    name: "ArtFrameRayTracer",
<<<<<<< HEAD
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
=======
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
>>>>>>> f9b290d (Initial ArtFrameRayTracer)
        .target(
            name: "ArtFrameCore",
            path: "Sources/ArtFrameCore"
        ),
<<<<<<< HEAD

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
=======
        .target(
            name: "ArtFrameRayTracer",
            dependencies: ["ArtFrameCore"],
            path: "Sources/ArtFrameRayTracer"
        ),
        .testTarget(
            name: "ArtFrameRayTracerTests",
            dependencies: ["ArtFrameRayTracer"]
        ),
>>>>>>> f9b290d (Initial ArtFrameRayTracer)
    ]
)
