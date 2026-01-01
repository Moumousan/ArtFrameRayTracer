//
//  FrameRecipe.swift
//  ArtFrameRayTracerUnit
//
//  Created by SNI on 2025/12/10.
//


// Sources/ArtFrameCore/Session.swift

import CoreGraphics
import Foundation
import simd


public struct FrameLockInfo: Codable, Hashable {
    public let lockedAt: Date
    public let unlockAt: Date

    public var isLockedNow: Bool {
        Date() < unlockAt
    }
}

public enum FrameStatus: Codable, Equatable {
    case editing
    case locked(FrameLockInfo)
}

public struct LightingConfig: Codable, Hashable {
    public var presetID: String   // LightingPreset.rawValue を入れる想定
    public var keyLightDirection: SIMD3<Float>
    public var keyLightIntensity: Float
    public var ambientIntensity: Float

    public init(
        presetID: String,
        keyLightDirection: SIMD3<Float>,
        keyLightIntensity: Float,
        ambientIntensity: Float
    ) {
        self.presetID = presetID
        self.keyLightDirection = keyLightDirection
        self.keyLightIntensity = keyLightIntensity
        self.ambientIntensity = ambientIntensity
    }
}

/// 実画像はアプリ側で管理するので、ここでは識別子のみ
public struct FramedPhotoSession: Identifiable, Codable {
    public let id: UUID
    public var frame: FrameRecipe
    public var imageIdentifier: String  // PHAsset localIdentifier / ファイルパスなど
    public var scale: CGFloat
    public var offset: CGSize
    public var lighting: LightingConfig
    public var status: FrameStatus

    /// フレームレイアウトとレンダリング解像度のポリシー。
    public var renderProfile: FrameRenderProfile

    public init(
        id: UUID = UUID(),
        frame: FrameRecipe,
        imageIdentifier: String,
        scale: CGFloat = 1.0,
        offset: CGSize = .zero,
        lighting: LightingConfig,
        status: FrameStatus = .editing,
        renderProfile: FrameRenderProfile = .default
    ) {
        self.id = id
        self.frame = frame
        self.imageIdentifier = imageIdentifier
        self.scale = scale
        self.offset = offset
        self.lighting = lighting
        self.status = status
        self.renderProfile = renderProfile
    }

    public var isLocked: Bool {
        if case .locked(let info) = status {
            return info.isLockedNow
        }
        return false
    }
}
