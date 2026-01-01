//
//  Outer Profile.swift
//  ArtFrameRayTracer
//
//  Created by SNI on 2026/01/01.
//


// Sources/ArtFrameCore/OuterProfile.swift

import Foundation
import CoreGraphics

/// Outer の「帯」の伸ばし方に関するポリシー
public struct OuterStretchPolicy: Codable, Hashable, Sendable {
    public enum Mode: String, Codable, Sendable {
        /// とりあえず「いい感じに自動で」フィットさせる
        case autoFit

        /// 一定長さのユニットをタイル状に並べて詰める
        case repeatedUnit

        /// 「何ユニットで構成するか」を指定して均等割り
        case fixedUnitCount
    }

    /// モード本体
    public var mode: Mode

    /// repeatedUnit 用の 1ユニット長さ（pt）
    public var unitLength: CGFloat?

    /// fixedUnitCount 用のユニット数
    public var unitCount: Int?

    // MARK: - コンビニエンス

    public static var autoFit: OuterStretchPolicy {
        .init(mode: .autoFit, unitLength: nil, unitCount: nil)
    }

    public static func repeatedUnit(_ length: CGFloat) -> OuterStretchPolicy {
        .init(mode: .repeatedUnit, unitLength: length, unitCount: nil)
    }

    public static func fixedUnitCount(_ count: Int) -> OuterStretchPolicy {
        .init(mode: .fixedUnitCount, unitLength: nil, unitCount: count)
    }
}

/// Outer を 3 分割して持つためのアセット名セット
public struct OuterSegmentAssets: Codable, Hashable, Sendable {
    /// コーナーに使うアセット（無い場合もあるので Optional）
    public var cornerAssetName: String?

    /// 中央モチーフ（リボン・紋章・ロゴ等）
    public var centerAssetName: String?

    /// 伸縮する帯部分のアセット（必須）
    public var stretchAssetName: String

    public init(
        cornerAssetName: String? = nil,
        centerAssetName: String? = nil,
        stretchAssetName: String
    ) {
        self.cornerAssetName = cornerAssetName
        self.centerAssetName = centerAssetName
        self.stretchAssetName = stretchAssetName
    }
}

/// 1 つの Outer デザインのプロファイル
public struct OuterProfile: Codable, Hashable, Identifiable, Sendable {
    /// 内部ID（"outer-simple-metal" など）
    public var id: String

    /// UI表示用名（"Simple Metal", "Baroque Gold" 等）
    public var displayName: String

    /// 3 セグメント分のアセット指定
    public var assets: OuterSegmentAssets

    /// 帯部分の伸ばし方
    public var stretchPolicy: OuterStretchPolicy

    /// 将来のためにメタデータも持てるようにしておく
    public var userInfo: [String: String]

    public init(
        id: String,
        displayName: String,
        assets: OuterSegmentAssets,
        stretchPolicy: OuterStretchPolicy = .autoFit,
        userInfo: [String: String] = [:]
    ) {
        self.id = id
        self.displayName = displayName
        self.assets = assets
        self.stretchPolicy = stretchPolicy
        self.userInfo = userInfo
    }
}

public extension OuterProfile {

    /// v0: かまぼこ型メタル風、角も中央もなし
    static let simpleMetal = OuterProfile(
        id: "outer-simple-metal",
        displayName: "Simple Metal",
        assets: .init(
            cornerAssetName: nil,
            centerAssetName: nil,
            stretchAssetName: "OuterSimpleMetal"
        ),
        stretchPolicy: .autoFit
    )

    /// 角だけ飾りがついたクラシック枠
    static let classicCorner = OuterProfile(
        id: "outer-classic-corner",
        displayName: "Classic Corners",
        assets: .init(
            cornerAssetName: "OuterClassicCorner",
            centerAssetName: nil,
            stretchAssetName: "OuterClassicRail"
        ),
        stretchPolicy: .repeatedUnit(48)  // 48pt の帯をタイルして詰める想定
    )

    /// コーナー＋中央モチーフ付きの「バロック入口」
    static let baroqueLight = OuterProfile(
        id: "outer-baroque-light",
        displayName: "Baroque Light",
        assets: .init(
            cornerAssetName: "OuterBaroqueCorner",
            centerAssetName: "OuterBaroqueCenter",
            stretchAssetName: "OuterBaroqueRail"
        ),
        stretchPolicy: .autoFit
    )
}
// すでにあるはず：
// public enum FrameSlot: String, ComboSlot { case outer, mat, inner }

/// Outer 用の ComboPart を OuterProfile でラップして扱いたい場合のヘルパ
public struct OuterPartProfile: Codable, Hashable, Identifiable {
    public var id: String
    public var displayName: String
    public var outerProfile: OuterProfile

    public init(
        id: String,
        displayName: String,
        outerProfile: OuterProfile
    ) {
        self.id = id
        self.displayName = displayName
        self.outerProfile = outerProfile
    }
}
public struct OuterStretchLayout {
    public var unitLength: CGFloat
    public var unitCount: Int
}

/// 1 辺分の「帯」レイアウトを計算する簡易ユーティリティ
public func computeOuterStretchLayout(
    sideLength: CGFloat,
    cornerSize: CGFloat,
    policy: OuterStretchPolicy
) -> OuterStretchLayout {

    let available = max(0, sideLength - 2 * cornerSize)

    switch policy.mode {
    case .autoFit:
        // ユニット数はとりあえず 1、本当に必要なら描画側で細工
        return .init(unitLength: available, unitCount: 1)

    case .repeatedUnit:
        let u = max(1, policy.unitLength ?? available)
        let n = max(1, Int(available / u.rounded(.down)))
        let actualUnit = n > 0 ? available / CGFloat(n) : available
        return .init(unitLength: actualUnit, unitCount: max(n, 1))

    case .fixedUnitCount:
        let n = max(1, policy.unitCount ?? 1)
        let unit = available / CGFloat(n)
        return .init(unitLength: unit, unitCount: n)
    }
}
