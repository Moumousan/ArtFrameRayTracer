//
//  FrameRenderProfile.swift
//  ArtFrameRayTracer
//
//  Created by SNI on 2026/01/01.
//


//
//  FrameRenderProfile.swift
//  ArtFrameCore
//
//  共通の「論理レイアウト」と「レンダリング解像度ポリシー」をまとめたプロファイル。
//  RayTracerCPU / Metal の両方がこれを参照する。
//

import Foundation
import CoreGraphics

/// フレーム全体を 1.0 x 1.0 の正方形とみなしたときの、
/// Outer / Mat / Inner の厚み比率と、
/// レンダリング解像度ポリシー（最大ピクセル数 & オーバーサンプリング倍率）を表現する。
public struct FrameRenderProfile: Sendable, Hashable {

    // MARK: - Layout ratios (0.0 ... 0.5 相当を想定)

    /// フレーム外側から内側へ向かう Outer の厚み比率。
    /// 例: 0.08 → 幅 size の 8% が Outer になる。
    public var outerThicknessRatio: CGFloat

    /// Outer の内側から Mat の内側端までの厚み比率。
    /// 例: 0.12 → 幅 size の 12% が Mat になる。
    public var matThicknessRatio: CGFloat

    /// Inner の線の厚み比率。
    /// 例: 0.01 → 幅 size の 1% が Inner の太さ。
    public var innerThicknessRatio: CGFloat

    // MARK: - Rendering policy

    /// レンダリング時に許容する「幅／高さの最大ピクセル数」。
    /// 4096 を指定すると、どちらか一辺が 4096px を超えないように内部解像度を抑える。
    public var maxRenderResolution: Int

    /// 表示サイズに対して、どれくらいオーバーサンプリングして描くか。
    /// 1.0 → 等倍、1.5〜2.0 → 少し高めに描いて最後に縮小。
    public var oversampleScale: CGFloat

    // MARK: - Init

    public init(
        outerThicknessRatio: CGFloat,
        matThicknessRatio: CGFloat,
        innerThicknessRatio: CGFloat,
        maxRenderResolution: Int,
        oversampleScale: CGFloat
    ) {
        self.outerThicknessRatio = outerThicknessRatio
        self.matThicknessRatio = matThicknessRatio
        self.innerThicknessRatio = innerThicknessRatio
        self.maxRenderResolution = maxRenderResolution
        self.oversampleScale = oversampleScale
    }
}

// MARK: - プリセット

public extension FrameRenderProfile {

    /// v0.x 系のデフォルトプロファイル。
    /// 4096px まで対応・1.5倍オーバーサンプリング。
    static let `default` = FrameRenderProfile(
        outerThicknessRatio: 0.08,
        matThicknessRatio:   0.12,
        innerThicknessRatio: 0.01,
        maxRenderResolution: 4096,
        oversampleScale:     1.5
    )
}