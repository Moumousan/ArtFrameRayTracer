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

// Local shim to avoid depending on ModernButtonKit2 from ArtFrameCore.
// Extend this if the real protocol has more requirements.
public protocol SelectableModeProtocol {
    var id: String { get }
    var displayName: String { get }
}

public struct FramePartMode: SelectableModeProtocol, Identifiable, Hashable, Sendable {
    public let id: String
    public let displayName: String
    public let part: FramePart?

    // MBG() が要求する
    public init(id: String, displayName: String, part: FramePart?) {
        self.id = id
        self.displayName = displayName
        self.part = part
    }

    // 何も選ばれていない状態
    public static let idle = FramePartMode(id: "idle",
                                           displayName: "-",
                                           part: nil)
}
