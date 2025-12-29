//
//  FramePresetID.swift
//  ArtFrameRayTracer
//
//  Created by SNI on 2025/12/29.
//


//
//  FramePresetTypes.swift
//  ArtFrameUI
//
//  Created by Kyoto Denno Kogei Kobo-sha on 2025/12/29.
//

import Foundation
import CoreGraphics
import ArtFrameCore
import ModernButtonKit2

/// プリセットのスロットID（Set A〜E）
///
/// - UI では MBG() のモードとして使う想定
public enum FramePresetID: String, CaseIterable, Identifiable, SelectableModeProtocol {
    case setA
    case setB
    case setC
    case setD
    case setE

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .setA: "Set A"
        case .setB: "Set B"
        case .setC: "Set C"
        case .setD: "Set D"
        case .setE: "Set E"
        }
    }

    /// UI に並べる順番（必要ならここで順序を制御）
    public static var uiModes: [FramePresetID] {
        [.setA, .setB, .setC, .setD, .setE]
    }
}

/// 1つのプリセットに保存する内容
///
/// v0.x では：
/// - Outer / Mat / Inner の“厚み”
/// - Mat のテクスチャID
/// を保存対象にしておく。
///
/// 将来：
/// - FramePart（Outer/Mat/Inner のコンボ）
/// - ライティング条件
/// - Photo の差し替え etc.
/// を追加拡張していけるようにしておく。
public struct FramePreset: Identifiable {
    public let id: FramePresetID

    public var outerThickness: CGFloat
    public var matThickness: CGFloat
    public var innerThickness: CGFloat

    /// MatTextureStyle.id（＝ `MatTextureStyle.id` と揃える）
    public var matStyleID: String

    public init(
        id: FramePresetID,
        outerThickness: CGFloat,
        matThickness: CGFloat,
        innerThickness: CGFloat,
        matStyleID: String
    ) {
        self.id = id
        self.outerThickness = outerThickness
        self.matThickness = matThickness
        self.innerThickness = innerThickness
        self.matStyleID = matStyleID
    }
}