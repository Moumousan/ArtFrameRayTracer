//
//  FramePartMode.swift
//  ArtFrameUI
//
//  Created by SNI on 2025/12/28.
//

import Foundation
import ArtFrameCore          // FramePart / FrameSlot
import ModernButtonKit2      // SelectableModeProtocol

/// MBG() で使う「額縁パーツ選択用モード」
public struct FramePartMode: Identifiable, Hashable, SelectableModeProtocol {

    /// SelectableModeProtocol
    public let id: String
    public let displayName: String

    /// Outer / Mat / Inner のどれ用か
    public let slot: FrameSlot

    /// 対応するパーツ（「なし」の場合は nil）
    public let part: FramePart?

    // MARK: - 初期化

    /// 実際の FramePart から生成
    public init(slot: FrameSlot, part: FramePart) {
        self.slot = slot
        self.part = part
        self.id = part.id
        self.displayName = part.name
    }

    /// 「なし」用のモード（Mat / Inner 用）
    /// title を変えれば「Choose…」など好きなラベルにできる
    public init(noneFor slot: FrameSlot, title: String = "Choose…") {
        self.slot = slot
        self.part = nil
        self.id = "none-\(slot.rawValue)"
        self.displayName = title
    }
}
