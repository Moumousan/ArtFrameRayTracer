//
//  ArtFrameRenderer.swift
//  ArtFrameRayTracer
//
//  Created by SNI on 2025/12/12.
//


//
//  ArtFrameRenderer.swift
//  ArtFrameRayTracer
//
//  共通レンダラーインターフェイス（CPU / Metal 両対応用）
//

import CoreGraphics
//import CoreGraphicsExtensions // なければ消してOK
import CoreFoundation
import Foundation

/// ArtFrame のレンダラー共通プロトコル
public protocol ArtFrameRenderer {
    /// プレビュー用レンダリング（現在の SimpleCompositingRenderer.renderPreview と同じ役割）
    func renderPreview(
        session: FramedPhotoSession,
        targetSize: CGSize
    ) throws -> CGImage

    // 将来、最終レンダリングなどを追加したくなったらここにメソッドを足す
    // func renderFinal(...) throws -> CGImage
    func renderFinal(
           session: FramedPhotoSession,
           targetSize: CGSize
       ) throws -> CGImage
}

/// バックエンド種別（現在は CPU のみ、将来 Metal を追加）
public enum RendererBackend: Sendable {
    case auto   // 端末を見て自動選択（iOSならMetal優先など）
    case cpu
    case metal
}

