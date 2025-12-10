//
//  ArtFrameRayTracerEngine.swift
//  ArtFrameRayTracerUnit
//
//  Created by SNI on 2025/12/10.
//


// Sources/ArtFrameRayTracer/ArtFrameRayTracerEngine.swift

import CoreGraphics
import ArtFrameCore

public protocol ArtFrameRayTracerEngine {
    /// プレビュー用（低解像度・軽量）
    func renderPreview(
        session: FramedPhotoSession,
        targetSize: CGSize
    ) throws -> CGImage

    /// 最終レンダー用（4096ベース）
    func renderFinal(
        session: FramedPhotoSession,
        targetSize: CGSize
    ) throws -> CGImage
}