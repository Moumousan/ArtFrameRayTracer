//
//  ComboSlot.swift
//  ArtFrameRayTracer
//
//  Created by SNI on 2025/12/27.
//


//
//  ComboCore.swift
//  ArtFrameCore
//
//  汎用の「組み合わせエンジン」コア
//

import Foundation

/// 「どの枠か？」
/// 例:
///   - 額縁: outer / mat / inner
///   - 寿司: neta / shari / topping
///   - ラーメン: noodle / soup / topping
public protocol ComboSlot: CaseIterable, Hashable, Identifiable, Codable, Sendable {
    /// UI 表示用の名称
    var displayName: String { get }
}

/// String rawValue の enum ならそのまま id にできる
public extension ComboSlot where Self: RawRepresentable, RawValue == String {
    var id: String { rawValue }
}

/// 1 つのパーツ（部品）
/// 例:
///   - outer 枠の「Baroque Gold」
///   - ネタの「中トロ」
///   - スープの「豚骨」
public struct ComboPart<S: ComboSlot>: Identifiable, Hashable, Codable, Sendable {
    public var id: String          // 型番や識別子
    public var slot: S             // outer / mat / inner, neta / shari / topping…
    public var name: String        // UI 表示名
    public var meta: [String: String]  // 任意メタ（素材, 価格, カテゴリ …）

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

/// 「1セットの組み合わせ」
/// 例:
///   - outer A + mat B + inner C
///   - ネタ + しゃり + トッピング
public struct ComboRecipe<S: ComboSlot, Part>: Identifiable, Hashable, Codable, Sendable
where Part: Identifiable & Hashable & Codable & Sendable {

    public var id: String
    public var parts: [S: Part]

    public init(id: String, parts: [S: Part]) {
        self.id = id
        self.parts = parts
    }
}
/// スロットごとの候補パーツ集合から、
/// 取りうる全組み合わせを生成するライブラリ
public struct ComboLibrary<S: ComboSlot, Part> {
    public var partsBySlot: [S: [Part]]

    public init(partsBySlot: [S: [Part]]) {
        self.partsBySlot = partsBySlot
    }

    /// 完全な組み合わせ（全スロットに Part が入っているもの）を列挙
    public func generateAllCombos() -> [[S: Part]] {
        let slots = Array(partsBySlot.keys)
        return combine(slots: slots, index: 0, current: [:])
    }

    private func combine(
        slots: [S],
        index: Int,
        current: [S: Part]
    ) -> [[S: Part]] {
        guard index < slots.count else {
            // 全スロット埋まったので 1 セット完成
            return [current]
        }
        let slot = slots[index]
        guard let candidates = partsBySlot[slot], !candidates.isEmpty else {
            // このスロットに候補が無ければスキップ
            return combine(slots: slots, index: index + 1, current: current)
        }

        var result: [[S: Part]] = []
        for p in candidates {
            var next = current
            next[slot] = p
            result += combine(slots: slots, index: index + 1, current: next)
        }
        return result
    }
}
