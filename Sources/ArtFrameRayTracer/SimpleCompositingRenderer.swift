//
//  SimpleCompositingRenderer.swift
//  ArtFrameRayTracerUnit
//
//  Created by SNI on 2025/12/10.
//

// Sources/ArtFrameRayTracer/SimpleCompositingRenderer.swift

import CoreGraphics
import CoreImage
import ArtFrameCore

@available(iOS 13.0, *)
public final class SimpleCompositingRenderer: ArtFrameRayTracerEngine {

    public init() {}

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

    private enum Quality {
        case preview
        case final
    }

    private func render(
        session: FramedPhotoSession,
        targetSize: CGSize,
        quality: Quality
    ) throws -> CGImage {

        let width = Int(targetSize.width)
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
            throw RendererError.contextCreationFailed
        }

        // 背景クリア
        ctx.setFillColor(CGColor(gray: 0.1, alpha: 1.0))
        ctx.fill(CGRect(origin: .zero, size: targetSize))

        // v0.1 の段階ではダミーとして中心にグラデーションを描いておく
        let rect = CGRect(origin: .zero, size: targetSize)
        drawFakeLighting(in: ctx, rect: rect, lighting: session.lighting)

        guard let image = ctx.makeImage() else {
            throw RendererError.imageCreationFailed
        }
        return image
    }

    private func drawFakeLighting(
        in ctx: CGContext,
        rect: CGRect,
        lighting: LightingConfig
    ) {
        // ここでは presetID を見て簡易なグラデーションを書く
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

    public enum RendererError: Error {
        case contextCreationFailed
        case imageCreationFailed
    }
}
