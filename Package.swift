// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

<<<<<<< HEAD
<<<<<<< HEAD

// swift-tools-version: 6.2
=======
>>>>>>> f9b290d (Initial ArtFrameRayTracer)
=======

>>>>>>> 0d1bfdd (Metalta対応)
import PackageDescription

let package = Package(
    name: "ArtFrameRayTracer",
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 0d1bfdd (Metalta対応)
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
<<<<<<< HEAD
    products: [
        .library(
            name: "ArtFrameRayTracer",
            targets: ["ArtFrameRayTracer"]
        )
    ],
    targets: [
        // 共通型・セッション・protocol
=======
=======
>>>>>>> 0d1bfdd (Metalta対応)
    products: [
        .library(
            name: "ArtFrameRayTracer",
            targets: ["ArtFrameRayTracer"]   // ← 外部に見せるのはこの1つ
        )
    ],
    targets: [
<<<<<<< HEAD
>>>>>>> f9b290d (Initial ArtFrameRayTracer)
=======
        // 内部ターゲット：外に見せない
>>>>>>> 0d1bfdd (Metalta対応)
        .target(
            name: "ArtFrameCore",
            path: "Sources/ArtFrameCore"
        ),
<<<<<<< HEAD
<<<<<<< HEAD

        // CPU レンダラー
=======

>>>>>>> 0d1bfdd (Metalta対応)
        .target(
            name: "ArtFrameRayTracerCPU",
            dependencies: ["ArtFrameCore"],
            path: "Sources/ArtFrameRayTracerCPU"
        ),

<<<<<<< HEAD
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
=======
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
>>>>>>> 0d1bfdd (Metalta対応)
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
<<<<<<< HEAD
        ),
>>>>>>> f9b290d (Initial ArtFrameRayTracer)
=======
        )
>>>>>>> 0d1bfdd (Metalta対応)
    ]
)
