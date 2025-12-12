// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.


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
            targets: ["ArtFrameRayTracer"]   // ← 外部に見せるのはこの1つ
        )
    ],
    targets: [
        // 内部ターゲット：外に見せない
        .target(
            name: "ArtFrameCore",
            path: "Sources/ArtFrameCore"
        ),

        .target(
            name: "ArtFrameRayTracerCPU",
            dependencies: ["ArtFrameCore"],
            path: "Sources/ArtFrameRayTracerCPU"
        ),

        .target(
            name: "ArtFrameRayTracerMetal",
            dependencies: ["ArtFrameCore"],
            path: "Sources/ArtFrameRayTracerMetal",
            exclude: [],   // 今は空フォルダでOK
            resources: [
                // Metal シェーダーを置いたらここに追加
                // .process("Shaders")
            ]
        ),

        // 外部公開API（Factory / Protocol）
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
