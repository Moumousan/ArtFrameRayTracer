//
//  FramePartMode.swift
//  ArtFrameRayTracer
//
//  Created by SNI on 2025/12/28.
//
//
// MBG() 用のモード。
// 1つの FramePart をラップしつつ、.idle も持てる汎用モード。

import Foundation
import ArtFrameCore          // FramePart / FrameSlot を使う
import ModernButtonKit2      // MBG のプロトコル'SelectableModeProtocol'を使う

/// MBG のレーンで使う「どのパーツを選択しているか」状態
public enum FramePartMode: Hashable {
    case idle
    case outer(FramePart)
    case mat(FramePart)
    case inner(FramePart)
}

// MARK: - 便利プロパティ

public extension FramePartMode {

    /// 対応するスロット（outer / mat / inner）
    var slot: FrameSlot? {
        switch self {
        case .idle:          return nil
        case .outer:         return .outer
        case .mat:           return .mat
        case .inner:         return .inner
        }
    }

    /// 対応するパーツ（未選択なら nil）
    var part: FramePart? {
        switch self {
        case .idle:
            return nil
        case .outer(let p),
             .mat(let p),
             .inner(let p):
            return p
        }
    }
}

// MARK: - MBG(ModernButtonKit2) 用ブリッジ

extension FramePartMode: SelectableModeProtocol {

    public var id: String {
        switch self {
        case .idle:
            return "idle"
        case .outer(let part):
            return "outer-\(part.id)"
        case .mat(let part):
            return "mat-\(part.id)"
        case .inner(let part):
            return "inner-\(part.id)"
        }
    }

    public var displayName: String {
        switch self {
        case .idle:
            return "—"
        case .outer(let part),
             .mat(let part),
             .inner(let part):
            return part.name
        }
    }
}
