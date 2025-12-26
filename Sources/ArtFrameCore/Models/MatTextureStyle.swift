//
//  MatTextureStyle.swift
//  ArtFrameRayTracer
//
//  Created by SNI on 2025/12/26.
//


import Foundation

public struct MatTextureStyle: Identifiable, Hashable, Codable, Sendable {
    public let id: String          // 内部ID
    public let displayName: String // UI表示名
    public let assetName: String   // テクスチャ画像名（Assets名 or ファイル名）

    public init(id: String, displayName: String, assetName: String) {
        self.id = id
        self.displayName = displayName
        self.assetName = assetName
    }
}