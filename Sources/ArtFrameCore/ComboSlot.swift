//
//  ComboSlot.swift
//  ArtFrameRayTracer
//
//  Created by SNI on 2025/12/27.
//

import Foundation

/// 汎用的な「スロット」概念。
/// 例: 額縁なら Outer / Mat / Inner など。
public protocol ComboSlot: Identifiable, Hashable, Codable {
    /// UI 表示用の名前 (例: "Outer", "Mat")
    var displayName: String { get }
}

/// スロットごとにパーツをまとめたライブラリ。
/// `partsBySlot` には「各スロットに属する候補パーツ」を入れておき、
/// `generateAllCombos()` で「全スロットに Part が入っているもの」を全列挙する。
public struct ComboLibrary<S, Part>: Codable
where S: ComboSlot, Part: Hashable & Codable {

    /// スロット別のパーツ候補一覧
    public var partsBySlot: [S: [Part]]

    /// (オプション) 確定レシピの一覧
    public var recipes: [ComboRecipe<S, Part>]

    public init(
        partsBySlot: [S: [Part]],
        recipes: [ComboRecipe<S, Part>] = []
    ) {
        self.partsBySlot = partsBySlot
        self.recipes = recipes
    }

    /// 全スロットに Part が入っている組み合わせを全列挙
    public func generateAllCombos() -> [[S: Part]] {
        let slots = Array(partsBySlot.keys)
        return combine(slots: slots, index: 0, current: [:])
    }

    private func combine(
        slots: [S],
        index: Int,
        current: [S: Part]
    ) -> [[S: Part]] {
        // 全スロット埋まったので 1 セット完成
        guard index < slots.count else {
            return [current]
        }

        let slot = slots[index]

        // このスロットに候補が無ければスキップ
        guard let candidates = partsBySlot[slot], !candidates.isEmpty else {
            return combine(slots: slots, index: index + 1, current: current)
        }

        var result: [[S: Part]] = []
        for part in candidates {
            var next = current
            next[slot] = part
            result.append(contentsOf: combine(slots: slots, index: index + 1, current: next))
        }
        return result
    }
}

/// 任意スロット S に属する 1 パーツ。
/// 額縁なら「Outer 用の◯◯」「Mat 用の△△」みたいなイメージ。
public struct ComboPart<S: ComboSlot>: Identifiable, Hashable, Codable {
    public let id: String        // 例: "outer-wood-001"
    public let slot: S           // どのスロット用か (FrameSlot.outer など)
    public let name: String      // UI 表示名
    public var meta: [String: String]  // 素材ID, 価格, カテゴリなどメタ情報

    public init(
        id: String,
        slot: S,
        name: String,
        meta: [String: String] = [:]
    ) {
        self.id = id
        self.slot = slot
        self.name = name
        self.meta = meta
    }
}
