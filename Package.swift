// swift-tools-version: 6.2

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
            targets: ["ArtFrameUI"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/Moumousan/ModernButtonKit2.git",
            from: "0.5.0"
        ),
        // .package(path: "../SecureDeliveryCore"),  // ← 必要なら復活
    ],
    targets: [
        // 共通ロジック
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

        // Metal レンダラー
        .target(
            name: "ArtFrameRayTracerMetal",
            dependencies: ["ArtFrameCore"],
            path: "Sources/ArtFrameRayTracerMetal"
        ),

        // レイトレ本体（UI 依存なし）
        .target(
            name: "ArtFrameRayTracer",
            dependencies: [
                "ArtFrameCore",
                "ArtFrameRayTracerCPU",
                "ArtFrameRayTracerMetal"
            ],
            path: "Sources/ArtFrameRayTracer"
        ),

        // 額装 UI（ここだけ MBG 依存）
        .target(
            name: "ArtFrameUI",
            dependencies: [
                "ArtFrameCore",
                "ArtFrameRayTracer",
               // .product(name: "ModernButtonKit2", package: "ModernButtonKit2")
            ],
            path: "Sources/ArtFrameUI"
        ),

        .testTarget(
            name: "ArtFrameRayTracerTests",
            dependencies: ["ArtFrameRayTracer"]
        )
    ]
)
