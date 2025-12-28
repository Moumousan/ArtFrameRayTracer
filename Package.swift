// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "ArtFrameRayTracer",
    platforms: [
        .iOS(.v18),
        .macOS(.v15)
    ],
    products: [
        .library(name: "ArtFrameCore",      targets: ["ArtFrameCore"]),
        .library(name: "ArtFrameRayTracer", targets: ["ArtFrameRayTracer"]),
        .library(name: "ArtFrameUI",        targets: ["ArtFrameUI"]),
    ],
    dependencies: [
        // UI だけが MBG を使う
        .package(
            url: "https://github.com/Moumousan/ModernButtonKit2.git",
            branch: "main"   // タグ整えるまでは branch: "main" の方が安全
        ),
    ],
    targets: [
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
            path: "Sources/ArtFrameRayTracerMetal"
        ),
        .target(
            name: "ArtFrameRayTracer",
            dependencies: [
                "ArtFrameCore",
                "ArtFrameRayTracerCPU",
                "ArtFrameRayTracerMetal"
            ],
            path: "Sources/ArtFrameRayTracer"
        ),
        .target(
            name: "ArtFrameUI",
            dependencies: [
                "ArtFrameCore",
                "ArtFrameRayTracer",
                .product(name: "ModernButtonKit2", package: "ModernButtonKit2")
            ],
            path: "Sources/ArtFrameUI"
        ),
        .testTarget(
            name: "ArtFrameRayTracerTests",
            dependencies: ["ArtFrameRayTracer"]
        )
    ]
)
