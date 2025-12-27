//
//  FrameSlot.swift
//  ArtFrameRayTracer
//
//  Created by SNI on 2025/12/27.
//


//
//  FrameComboTypes.swift
//  ArtFrameCore
//

import Foundation

/// 額縁の 3 スロット（Outer / Mat / Inner）
///
/// ComboSlot は「一般概念」なので、
/// 実際のアプリではこの FrameSlot を使う。
// MARK: - ComboSlot / Identifiable
/// 額縁の 3 スロット（Outer / Mat / Inner）
/// 額縁の 3 スロット（Outer / Mat / Inner）
public enum FrameSlot: String, ComboSlot {
    case outer
    case mat
    case inner

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .outer: "Outer"
        case .mat:   "Mat"
        case .inner: "Inner"
        }
    }
}

/// 額縁パーツ（Outer / Mat / Inner のどれかに属する 1 パーツ）
public typealias FramePart = ComboPart<FrameSlot>

/// 額縁のレシピ（3 スロットの組み合わせ）
public typealias FrameRecipe = ComboRecipe<FrameSlot, FramePart>

/// 額縁パーツ & レシピのライブラリ
public typealias FrameLibrary = ComboLibrary<FrameSlot, FramePart>
