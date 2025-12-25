//
//  MouldingSectionProfile.swift
//  ArtFrameRayTracer
//
//  Created by SNI on 2025/12/25.
//


//
//  MouldingSectionProfile.swift
//  ArtFrameCore
//
//  Created by SNI on 2025/12/25.
//

import CoreGraphics

/// モールディングの断面プロファイル（2D）
/// Outer / Inner の「断面だけ」を表現する軽量モデル。
public struct MouldingSectionProfile: Identifiable, Codable, Sendable {
    public var id: String

    /// フレーム全体の幅（短辺に対する割合）。
    /// 例: 0.08 ならキャンバス短辺の8%。
    public var width: CGFloat

    /// 壁からの最大出っ張り量（高さ）。
    public var height: CGFloat

    /// 手前側の丸み（R）。
    public var frontRadius: CGFloat

    /// 奥側の丸み（R）。
    public var backRadius: CGFloat

    /// 段差・えぐりなどの深さ（シンプル版なら 0 でもOK）。
    public var stepDepth: CGFloat

    public init(
        id: String,
        width: CGFloat,
        height: CGFloat,
        frontRadius: CGFloat,
        backRadius: CGFloat,
        stepDepth: CGFloat
    ) {
        self.id = id
        self.width = width
        self.height = height
        self.frontRadius = frontRadius
        self.backRadius = backRadius
        self.stepDepth = stepDepth
    }
}