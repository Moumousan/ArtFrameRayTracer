//
//  MatPreviewModel.swift
//  ArtFrameUI
//
//  Created by Kyoto Denno Kogei Kobo-sha on 2025/12/26.
//

import SwiftUI
import Combine
import ArtFrameCore

#if os(macOS)
import AppKit
#endif

/// 工房とビューワ（MatViewerView / DemoFrameView など）が共有する状態モデル。
///
/// v0.x では：
/// - Outer / Mat / Inner の厚み
/// - Mat のテクスチャ
/// - Photo
/// - 簡易レイトレ結果
/// - Set A〜E のプリセット
/// を扱う。
@MainActor
public final class MatPreviewModel: ObservableObject {

    // MARK: - Thickness (Outer / Mat / Inner)

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

    // MARK: - Presets (Set A〜E)

    /// 現在フォーカスしているプリセット（初期は Set A）
    @Published public var activePreset: FramePresetID = .setA

    /// Set A〜E の状態
    @Published public var presets: [FramePresetID: FramePreset] = [:]

    /// 現在の Thickness + MatTexture をプリセットとして保存
    public func saveCurrentState(to presetID: FramePresetID) {
        let preset = FramePreset(
            id: presetID,
            outerThickness: outerThickness,
            matThickness: matThickness,
            innerThickness: innerThickness,
            matStyleID: selectedMatStyleID
        )
        presets[presetID] = preset
    }

    /// プリセットの状態を現在の編集状態へロード
    public func loadPreset(_ presetID: FramePresetID) {
        guard let preset = presets[presetID] else { return }
        outerThickness = preset.outerThickness
        matThickness = preset.matThickness
        innerThickness = preset.innerThickness
        selectedMatStyleID = preset.matStyleID
    }

    /// UI 用の説明テキスト
    public var currentSetDescription: String {
        let preset = presets[activePreset]

        let matName: String = {
            if let id = preset?.matStyleID,
               let s = matStyles.first(where: { $0.id == id }) {
                return s.displayName
            }
            return selectedMatStyle.displayName
        }()

        let outerText = String(format: "%.0f pt", preset?.outerThickness ?? outerThickness)
        let matText   = String(format: "%.0f pt", preset?.matThickness   ?? matThickness)
        let innerText = String(format: "%.0f pt", preset?.innerThickness ?? innerThickness)

        return """
        Outer: \(outerText), Mat: \(matText), Inner: \(innerText)
        Mat Texture: \(matName)
        """
    }

    // MARK: - Photo & Raytraced Image (macOS)

    #if os(macOS)
    @Published public var photo: NSImage? = nil
    @Published public var raytracedImage: CGImage? = nil
    #endif

    // MARK: - Init

    public init() {
        // 起動直後は「現在の状態」をそのまま Set A にコピーしておく
        let initial = FramePreset(
            id: .setA,
            outerThickness: outerThickness,
            matThickness: matThickness,
            innerThickness: innerThickness,
            matStyleID: selectedMatStyleID
        )
        self.presets = [.setA: initial]
    }

    // MARK: - Dummy RayTracer (v0.x)

    #if os(macOS)
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
