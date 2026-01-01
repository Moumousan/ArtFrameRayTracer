//
//  ArtFrameRayTracerMetal.swift
//  ArtFrameRayTracer
//
//  Created by SNI on 2025/12/12.
//

import CoreGraphics
import ArtFrameCore
import Metal

@available(iOS 15.0, macOS 12.0, *)
public final class MetalRayTracerRenderer: ArtFrameRenderer {

    private let device: MTLDevice

    public init?(device: MTLDevice? = MTLCreateSystemDefaultDevice()) {
        guard let device else { return nil }
        self.device = device
        // TODO: 将来ここで Metal のパイプライン / シェーダを初期化する
    }

    // MARK: - Public API (ArtFrameRenderer)

    public func renderPreview(
        session: FramedPhotoSession,
        targetSize: CGSize
    ) throws -> CGImage {
        try render(session: session, targetSize: targetSize, quality: .preview)
    }

    public func renderFinal(
        session: FramedPhotoSession,
        targetSize: CGSize
    ) throws -> CGImage {
        try render(session: session, targetSize: targetSize, quality: .final)
    }

    // MARK: - Internal

    private enum Quality {
        case preview
        case final
    }

    private func render(
        session: FramedPhotoSession,
        targetSize: CGSize,
        quality: Quality
    ) throws -> CGImage {

        // 共通ポリシー（FrameRenderProfile）を取得
        let profile = session.renderProfile

        // 1. 要求されている最終サイズ（ピクセル前提）
        let requestedWidth = max(targetSize.width, 1)
        let requestedHeight = max(targetSize.height, 1)
        let longestSide = max(requestedWidth, requestedHeight)

        // 2. 品質ごとのオーバーサンプリング倍率
        //    - preview: 等倍もしくはそれ以下（高速優先）
        //    - final:   プロファイル指定どおり
        let baseOversample = profile.oversampleScale
        let desiredOversample: CGFloat
        switch quality {
        case .preview:
            desiredOversample = min(baseOversample, 1.0)
        case .final:
            desiredOversample = baseOversample
        }

        // 3. 最大レンダリング解像度を超えないようにクランプ
        let maxRes = CGFloat(profile.maxRenderResolution)
        let maxScaleByResolution = maxRes / max(longestSide, 1.0)
        let actualScale = min(desiredOversample, maxScaleByResolution)

        let internalWidth = max(1, Int((requestedWidth * actualScale).rounded(.toNearestOrAwayFromZero)))
        let internalHeight = max(1, Int((requestedHeight * actualScale).rounded(.toNearestOrAwayFromZero)))

        // ★ 現時点では「MetalRayTracerRenderer」だが、
        //   中身は CPU と同様に CGContext で簡易グラデーションを描画する。
        //   将来ここを Metal ベースのレンダリングに差し替える。

        guard let ctx = CGContext(
            data: nil,
            width: internalWidth,
            height: internalHeight,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            throw RendererError.contextCreationFailed
        }

        let internalSize = CGSize(width: internalWidth, height: internalHeight)
        let rect = CGRect(origin: .zero, size: internalSize)

        // 背景
        ctx.setFillColor(CGColor(gray: 0.1, alpha: 1.0))
        ctx.fill(rect)

        // v0.x 仮実装：簡易ライティング（グラデーション）
        drawFakeLighting(in: ctx, rect: rect, lighting: session.lighting)

        guard let rawImage = ctx.makeImage() else {
            throw RendererError.imageCreationFailed
        }

        // 将来: 必要ならここで targetSize にダウンサンプリングして返す。
        return rawImage
    }

    // MARK: - 仮のライティング実装（CPU 側 SimpleCompositingRenderer と揃える）

    private func drawFakeLighting(
        in ctx: CGContext,
        rect: CGRect,
        lighting: LightingConfig
    ) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors: [CGColor] = [
            CGColor(gray: 0.2, alpha: 1.0),
            CGColor(gray: 0.8, alpha: 1.0)
        ]

        guard let gradient = CGGradient(
            colorsSpace: colorSpace,
            colors: colors as CFArray,
            locations: [0.0, 1.0]
        ) else { return }

        let start: CGPoint
        let end: CGPoint

        switch lighting.presetID {
        case LightingPreset.montblancLeftTop.rawValue:
            start = CGPoint(x: 0, y: 0)
            end = CGPoint(x: rect.maxX, y: rect.maxY)
        case LightingPreset.top.rawValue:
            start = CGPoint(x: rect.midX, y: 0)
            end = CGPoint(x: rect.midX, y: rect.maxY)
        case LightingPreset.rightTop.rawValue:
            start = CGPoint(x: rect.maxX, y: 0)
            end = CGPoint(x: 0, y: rect.maxY)
        case LightingPreset.bottom.rawValue:
            start = CGPoint(x: rect.midX, y: rect.maxY)
            end = CGPoint(x: rect.midX, y: 0)
        case LightingPreset.centerSpot.rawValue:
            start = CGPoint(x: rect.midX, y: rect.midY)
            end = CGPoint(x: rect.midX, y: rect.midY + rect.height * 0.6)
        default:
            start = CGPoint(x: 0, y: 0)
            end = CGPoint(x: rect.maxX, y: rect.maxY)
        }

        ctx.saveGState()
        ctx.drawLinearGradient(
            gradient,
            start: start,
            end: end,
            options: []
        )
        ctx.restoreGState()
    }

    // MARK: - Error

    public enum RendererError: Error {
        case contextCreationFailed
        case imageCreationFailed
    }
}
