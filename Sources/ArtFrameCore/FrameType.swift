//
//  FramePartPackID.swift
//  ArtFrameRayTracerUnit
//
//  Created by SNI on 2025/12/10.
//


// Sources/ArtFrameCore/FrameTypes.swift

import CoreGraphics
import simd

public struct FramePartPackID: RawRepresentable, Hashable, Codable, Sendable {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }

    public static let initial = FramePartPackID(rawValue: "initial-1")
    public static let specialStamp = FramePartPackID(rawValue: "special-launch-stamp")
}

public protocol PackableFramePart {
    var packID: FramePartPackID { get }
}

// MARK: - Outer

public enum OuterCategory: String, Codable, CaseIterable, Sendable {
    case wafu
    case classic
    case modern
    case special   // 切手など
}

public struct OuterFrameStyle: Identifiable, Hashable, PackableFramePart, Codable, Sendable {
    public let id: String
    public let packID: FramePartPackID
    public var category: OuterCategory
    public var name: String
    public var width: CGFloat   // 絵に対する割合
    public var depth: CGFloat   // 奥行き
    public var materialID: String
    public var sectionProfileID: String? // 断面プロファイルID（工房アプリで作成。nilなら従来どおりの簡易形状）

    public init(
        id: String,
        packID: FramePartPackID,
        category: OuterCategory,
        name: String,
        width: CGFloat,
        depth: CGFloat,
        materialID: String,
        sectionProfileID: String? = nil
    ) {
        self.id = id
        self.packID = packID
        self.category = category
        self.name = name
        self.width = width
        self.depth = depth
        self.materialID = materialID
        self.sectionProfileID = sectionProfileID
    }
}

// MARK: - Mat

public enum MatCategory: String, Codable, CaseIterable, Sendable {
    case neutral
    case pastel
    case vivid
    case texture
    case pattern
}

public struct MatStyle: Identifiable, Hashable, PackableFramePart, Codable, Sendable {
    public let id: String
    public let packID: FramePartPackID
    public var category: MatCategory
    public var name: String
    public var margin: CGFloat
    public var materialID: String
}

// MARK: - Inner

public enum InnerCategory: String, Codable, CaseIterable, Sendable {
    case simple
    case shape
    case decor
}

public struct InnerFrameStyle: Identifiable, Hashable, PackableFramePart, Codable, Sendable {
    public let id: String
    public let packID: FramePartPackID
    public var category: InnerCategory
    public var name: String
    public var width: CGFloat
    public var materialID: String
    public var sectionProfileID: String?
}
