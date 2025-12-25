//
//  SectionProfileLibrary.swift
//  ArtFrameRayTracer
//
//  Created by SNI on 2025/12/25.
//


//
//  SectionProfileLibrary.swift
//  ArtFrameCore
//
//  Created by SNI on 2025/12/25.
//

/// 断面プロファイルをまとめて管理するライブラリ。
public struct SectionProfileLibrary: Codable, Sendable {
    public var profiles: [MouldingSectionProfile]

    public init(profiles: [MouldingSectionProfile]) {
        self.profiles = profiles
    }

    public func profile(for id: String) -> MouldingSectionProfile? {
        profiles.first { $0.id == id }
    }
}

/// v0 のデフォルトプロファイル群（必要に応じて増やす）
public enum DefaultSectionProfiles {
    public static let outerSimple: [MouldingSectionProfile] = [
        .init(
            id: "outer-simple-kamaboko",
            width: 0.08,
            height: 0.04,
            frontRadius: 0.02,
            backRadius: 0.0,
            stepDepth: 0.0
        ),
        .init(
            id: "outer-simple-flat",
            width: 0.08,
            height: 0.02,
            frontRadius: 0.0,
            backRadius: 0.0,
            stepDepth: 0.0
        )
    ]

    public static let innerSimple: [MouldingSectionProfile] = [
        .init(
            id: "inner-thin-round",
            width: 0.03,
            height: 0.015,
            frontRadius: 0.015,
            backRadius: 0.0,
            stepDepth: 0.0
        ),
        .init(
            id: "inner-thin-flat",
            width: 0.02,
            height: 0.01,
            frontRadius: 0.0,
            backRadius: 0.0,
            stepDepth: 0.0
        )
    ]

    public static let all: SectionProfileLibrary = .init(
        profiles: outerSimple + innerSimple
    )
}