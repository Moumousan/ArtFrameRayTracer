// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ArtFrameRayTracer",
    platforms: [
        .iOS(.v18),
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "ArtFrameCore",
            targets: ["ArtFrameCore"]
        ),
        .library(
            name: "ArtFrameRayTracer",
            targets: ["ArtFrameRayTracer"]
        ),
        .library(
            name: "ArtFrameUI",
            targets: ["ArtFrameUI"]        //
        )
    ],
    dependencies: [
            // ここを追加（パスは実際の配置に合わせて調整）
            .package(path: "../SecureDeliveryCore")
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
        
        //  額装UI
        .target(
            name: "ArtFrameUI",
            dependencies: [
                "ArtFrameCore",
                "ArtFrameRayTracer"   // ← エンジンを使う
            ],
            path: "Sources/ArtFrameUI"
        ),

        .testTarget(
            name: "ArtFrameRayTracerTests",
            dependencies: ["ArtFrameRayTracer"]
        )
    ]
)
