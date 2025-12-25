//
//  ArtFrameContainer.swift
//  ArtFrameUI
//
//  Created by SNI on 2025/12/13.
//


// Sources/ArtFrameUI/ArtFrameContainer.swift

import SwiftUI
import ArtFrameCore
import ArtFrameRayTracer

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension Color {
    static var artFramePlaceholderBackground: Color {
        #if canImport(UIKit)
        return Color(UIColor.secondarySystemBackground)
        #elseif canImport(AppKit)
        return Color(NSColor.windowBackgroundColor)
        #else
        return Color.gray.opacity(0.2)
        #endif
    }
}

/// どんな View でも ArtFrame で額装する汎用コンテナ
public struct ArtFrameContainer<Content: View>: View {
    // ベースとなる枠レシピとライティング
    public let recipe: FrameRecipe
    public let lighting: LightingPreset
    public let options: ArtFrameOptions
    public let content: Content
    
    // 内部で使用するレンダラー
    private let renderer: any ArtFrameRenderer = ArtFrameRendererFactory.make(
        preferred: .auto
    )
    // もしくは iOS でもあえて CPU(metal) 固定にしたいなら：
    // private let renderer: any ArtFrameRenderer = ArtFrameRendererFactory.make(preferred:.cpu(metal))
    
    @State private var frameImage: CGImage?
    @State private var isRendering: Bool = false
    @State private var lastRenderKey: String = ""
    
    public init(
        recipe: FrameRecipe,
        lighting: LightingPreset,
        options: ArtFrameOptions = .minimal,
        @ViewBuilder content: () -> Content
    ) {
        self.recipe = recipe
        self.lighting = lighting
        self.options = options
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                // 背景：レイトレされた額縁
                if let frameImage {
                    FrameBackgroundView(cgImage: frameImage)
                        .frame(width: geo.size.width, height: geo.size.height)
                } else {
                    // 未レンダリング時のプレースホルダ
                    Color.artFramePlaceholderBackground
                }
                
                // 内側：ユーザーのコンテンツ
                VStack(spacing: 0) {
                    // 将来: options.showsMatCommandBar で Mat 上部バーを入れる
                    
                    VStack(spacing: 0) {
                        content
                    }
                    .padding(options.innerPadding)
                    
                    // 将来: options.showsBrassPlate でプレートを入れる（Photo/Terminal）
                }
            }
            .task {
                await renderIfNeeded(targetSize: geo.size)
            }
        }
    }
    
    // MARK: - レンダリング

    /// レシピ or ライティング or サイズが変わったら再レンダリング
    private func renderKey(for size: CGSize) -> String {
        "\(recipe.id)-\(lighting.rawValue)-\(Int(size.width))x\(Int(size.height))"
    }
    
    @MainActor
    private func renderIfNeeded(targetSize: CGSize) async {
        let newKey = renderKey(for: targetSize)
        guard newKey != lastRenderKey else { return }
        lastRenderKey = newKey
        isRendering = true
        
        // v0.1: 写真はまだ使わず、ダミーの imageIdentifier を使用
        let session = FramedPhotoSession(
            frame: recipe,
            imageIdentifier: "ArtFrameUI-Dummy",
            scale: 1.0,
            offset: .zero,
            lighting: lighting.config,
            status: .editing
        )
        
        do {
            let cgImage = try renderer.renderPreview(
                session: session,
                targetSize: targetSize
            )
            frameImage = cgImage
        } catch {
            // 本番ではロギングなど入れる
            print("ArtFrameContainer: render failed: \(error)")
        }
        
        isRendering = false
    }
}

/// CGImage をプラットフォームごとの Image に変換する小さな View
struct FrameBackgroundView: View {
    let cgImage: CGImage
    
    var body: some View {
        #if os(macOS)
        let nsImage = NSImage(
            cgImage: cgImage,
            size: NSSize(width: cgImage.width, height: cgImage.height)
        )
        Image(nsImage: nsImage)
            .resizable()
            .scaledToFill()
        #else
        Image(uiImage: UIImage(cgImage: cgImage))
            .resizable()
            .scaledToFill()
        #endif
    }
}
