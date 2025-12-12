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
        // 将来: パイプラインやライブラリのセットアップ
    }

    public func renderPreview(
        session: FramedPhotoSession,
        targetSize: CGSize
    ) throws -> CGImage {
        // ★ いまは CPU にフォールバックしてもOK
        // あるいは単純なグラデーションだけでもいい
        throw NSError(domain: "MetalRenderer", code: -1,
                      userInfo: [NSLocalizedDescriptionKey: "Metal renderer not implemented yet"])
    }

    public func renderFinal(
        session: FramedPhotoSession,
        targetSize: CGSize
    ) throws -> CGImage {
        try renderPreview(session: session, targetSize: targetSize)
    }
}
