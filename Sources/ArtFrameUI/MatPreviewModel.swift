//
//  MatPreviewModel.swift
//  ArtFramePartsStudio
//
//  Created by SNI on 2025/12/26.
//

import SwiftUI
import Combine
import ArtFrameCore
#if os(macOS)
import AppKit
#endif


/// 工房とビューワが共有する状態
/// ArtFrame 系アプリで共有する、
/// 「Outer / Mat / Inner + 写真」の状態モデル。
///
/// - 工房パネル
/// - 簡易プレビュー
/// - レイトレ結果プレビュー
///
/// など、複数のビューから参照される前提。
///
@MainActor
final class MatPreviewModel: ObservableObject {

    // MARK: - Frame Thickness

    @Published public var outerThickness: CGFloat = 40
    @Published public var matThickness: CGFloat = 80
    @Published public var innerThickness: CGFloat = 8

    // MARK: - Mat Textures

    @Published public var matStyles: [MatTextureStyle] = [
        .init(id: "wood",
              displayName: "Weathered Wood",
              assetName: "MatTextureSample"),
        .init(id: "plain",
              displayName: "Plain Paper",
              assetName: "MatTexturePlain"),
        .init(id: "catPaws",
              displayName: "Cat Paws",
              assetName: "MatTextureCatPaws")
    ]

    @Published public var selectedMatStyleID: String = "wood"

    public var selectedMatStyle: MatTextureStyle {
        matStyles.first { $0.id == selectedMatStyleID } ?? matStyles[0]
    }
    
    /// v0.x 標準プリセット全部入りライブラリ
    @Published public var frameLibrary: FrameLibrary = DefaultPacks.initialFrameLibrary

    /// Outer / Mat / Inner 用の候補パーツ
    public var outerParts: [FramePart] { frameLibrary.partsBySlot[.outer] ?? [] }
    public var matParts:   [FramePart] { frameLibrary.partsBySlot[.mat]   ?? [] }
    public var innerParts: [FramePart] { frameLibrary.partsBySlot[.inner] ?? [] }

    // MARK: - MBG() 用のモード配列（idle を含む）

    public var outerModes: [FramePartMode] {
        [.idle] + outerParts.map { .outer($0) }
    }

    public var matModes: [FramePartMode] {
        [.idle] + matParts.map { .mat($0) }
    }

    public var innerModes: [FramePartMode] {
        [.idle] + innerParts.map { .inner($0) }
    }

    // MARK: - MBG() 用の選択状態

    @Published public var selectedOuterMode: FramePartMode = .idle
    @Published public var selectedMatMode:   FramePartMode = .idle
    @Published public var selectedInnerMode: FramePartMode = .idle

    /// 現在選択されている実パーツ（必要になったら使う）
    public var selectedOuterPart: FramePart? { selectedOuterMode.part }
    public var selectedMatPart:   FramePart? { selectedMatMode.part }
    public var selectedInnerPart: FramePart? { selectedInnerMode.part }

    // MARK: - Photo & Rendered Image (macOS)

    #if os(macOS)
    @Published public var photo: NSImage? = nil
    @Published public var raytracedImage: CGImage? = nil

    // MARK: - Photo helper and dummy RayTracer

    /// 選択中の写真を SwiftUI.Image として参照したい場合に使うヘルパ
    public var photoImage: Image? {
        guard let photo else { return nil }
        return Image(nsImage: photo)
    }

    /// 現在の設定で簡易的なグラデーション画像を生成する。
    /// 後で ArtFrameRayTracer の本格レイトレに差し替える前提。
    public func renderWithRayTracer(targetSize: CGSize) {
        let width  = Int(targetSize.width)
        let height = Int(targetSize.height)

        guard let ctx = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            raytracedImage = nil
            return
        }

        let rect = CGRect(origin: .zero, size: targetSize)

        // 背景を暗めのグレーで塗る
        ctx.setFillColor(CGColor(gray: 0.10, alpha: 1.0))
        ctx.fill(rect)

        // 左上から右下への簡易ライト（グラデーション）
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors: [CGColor] = [
            CGColor(gray: 0.85, alpha: 1.0),
            CGColor(gray: 0.20, alpha: 1.0)
        ]

        if let gradient = CGGradient(
            colorsSpace: colorSpace,
            colors: colors as CFArray,
            locations: [0.0, 1.0]
        ) {
            ctx.drawLinearGradient(
                gradient,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: rect.maxX, y: rect.maxY),
                options: []
            )
        }

        raytracedImage = ctx.makeImage()
    }
    #endif
}

