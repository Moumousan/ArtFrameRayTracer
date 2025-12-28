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


public extension ComboLibrary where S == FrameSlot, Part == FramePart {

    /// Outer は必須、Mat/Inner は nil を含めた全組み合わせで
    /// FrameRecipe を生成して self.recipes に詰める。
    mutating func generateAllFrameRecipes(
        idPrefix: String = "frame-"
    ) {
        let outers = partsBySlot[.outer] ?? []
        let mats   = partsBySlot[.mat]   ?? []
        let inners = partsBySlot[.inner] ?? []

        // 「なし」込みの候補
        let matsWithNone:   [FramePart?] = [nil] + mats
        let innersWithNone: [FramePart?] = [nil] + inners

        var all: [FrameRecipe] = []
        var counter = 0

        for outer in outers {
            for mat in matsWithNone {
                for inner in innersWithNone {
                    counter += 1

                    var parts: [FrameSlot: FramePart?] = [.outer: outer]
                    parts[.mat]   = mat
                    parts[.inner] = inner

                    // ※ FrameRecipe のイニシャライザに合わせてここは調整して下さい
                    let recipe = FrameRecipe(
                        id: "\(idPrefix)\(counter)",
                        parts: parts as! [FrameSlot : FramePart]
                    )
                    all.append(recipe)
                }
            }
        }

        self.recipes = all
    }
}
