//
//  ComboRecipe.swift
//  ArtFrameCore
//
//  Created by SNI on 2025/12/28.
//

import Foundation

/// 任意のスロット S に対して、パーツ Part を割り当てたレシピ。
/// 例: S = FrameSlot (outer/mat/inner), Part = FramePart など。
public struct ComboRecipe<S, Part>: Identifiable, Hashable, Codable
where S: ComboSlot,
      Part: Hashable & Codable {

    /// レシピID（"frame-1" など）
    public let id: String

    /// スロットごとのパーツ割り当て
    public var parts: [S: Part]

    public init(id: String, parts: [S: Part]) {
        self.id = id
        self.parts = parts
    }
}
