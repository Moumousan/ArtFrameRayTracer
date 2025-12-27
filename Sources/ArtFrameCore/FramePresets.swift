//
//  DefaultPacks.swift
//  ArtFrameRayTracerUnit
//
//  Created by SNI on 2025/12/10.
//

// Sources/ArtFrameCore/FramePresets.swift

import CoreGraphics

public enum DefaultPacks {
    public static let outer: [OuterFrameStyle] = [
        .init(
            id: "outer-kumiko-natural",
            packID: .initial,
            category: .wafu,
            name: "Kumiko Natural",
            width: 0.12,
            depth: 0.05,
            materialID: "mat-wood-kumiko",
            sectionProfileID: "outer-simple-flat"
        ),
        .init(
            id: "outer-modern-black",
            packID: .initial,
            category: .modern,
            name: "Modern Black",
            width: 0.08,
            depth: 0.03,
            materialID: "metal-anodized-black",
            sectionProfileID: "outer-simple-kamaboko"
        ),
        .init(
            id: "outer-baroque-gold",
            packID: .initial,
            category: .classic,
            name: "Baroque Gold",
            width: 0.14,
            depth: 0.06,
            materialID: "gold-baroque"
        ),
        // 将来: 切手フレーム（special）
        .init(
            id: "outer-stamp-frame",
            packID: .specialStamp,
            category: .special,
            name: "Stamp Frame",
            width: 0.10,
            depth: 0.02,
            materialID: "paper-stamp"
            // sectionProfileID は未設定でもよい
        )
    ]

    public static let mats: [MatStyle] = [
        .init(
            id: "mat-kinari",
            packID: .initial,
            category: .neutral,
            name: "Kinari",
            margin: 0.06,
            materialID: "paper-kinari"
        ),
        .init(
            id: "mat-sakura",
            packID: .initial,
            category: .pastel,
            name: "Sakura Pastel",
            margin: 0.07,
            materialID: "paper-sakura"
        ),
        .init(
            id: "mat-catpaw",
            packID: .initial,
            category: .pattern,
            name: "Cat Paw Pattern",
            margin: 0.08,
            materialID: "pattern-catpaw"
        )
    ]

    public static let inners: [InnerFrameStyle] = [
        .init(
            id: "inner-gold-thin",
            packID: .initial,
            category: .simple,
            name: "Gold Thin",
            width: 0.02,
            materialID: "metal-gold-thin",
            sectionProfileID: "inner-thin-flat"
        ),
        .init(
            id: "inner-round",
            packID: .initial,
            category: .shape,
            name: "Round",
            width: 0.025,
            materialID: "coating-round",
            sectionProfileID: "inner-thin-round"
        ),
        .init(
            id: "inner-sharp",
            packID: .initial,
            category: .shape,
            name: "Sharp",
            width: 0.02,
            materialID: "coating-sharp",
            sectionProfileID: "inner-thin-sharp"
        )
    ]
}

// 全組み合わせを生成するヘルパ
public struct FrameLibrary {
    public var outers: [OuterFrameStyle]
    public var mats: [MatStyle]
    public var inners: [InnerFrameStyle]

    public init(
        outers: [OuterFrameStyle] = DefaultPacks.outer,
        mats: [MatStyle] = DefaultPacks.mats,
        inners: [InnerFrameStyle] = DefaultPacks.inners
    ) {
        self.outers = outers
        self.mats = mats
        self.inners = inners
    }

    public func generateAllRecipes() -> [FrameRecipe] {
        var result: [FrameRecipe] = []
        var counter = 0

        let matsWithNone: [MatStyle?] = [nil] + mats.map { Optional($0) }
        let innersWithNone: [InnerFrameStyle?] = [nil] + inners.map { Optional($0) }

        for outer in outers {
            for mat in matsWithNone {
                for inner in innersWithNone {
                    counter += 1
                    let id = "frame-\(counter)"
                    result.append(
                        FrameRecipe(id: id, outer: outer, mat: mat, inner: inner)
                    )
                }
            }
        }
        return result
    }
}


// ComboCore Mapping
// MARK: - ArtFrame 専用 ComboSlot

public enum FrameSlot: String, ComboSlot {
    case outer
    case mat
    case inner

    public var displayName: String {
        switch self {
        case .outer: "Outer"
        case .mat:   "Mat"
        case .inner: "Inner"
        }
    }
}

// MARK: - DefaultPacks → ComboPart マッピング

public extension DefaultPacks {

    /// OuterFrameStyle 群を ComboPart<FrameSlot> に変換
    static var outerComboParts: [ComboPart<FrameSlot>] {
        outer.map { outerStyle in
            ComboPart(
                id: outerStyle.id,
                slot: .outer,
                name: outerStyle.name,
                meta: [
                    "materialID": outerStyle.materialID,
                    "category": outerStyle.category.rawValue,
                    "packID": outerStyle.packID.rawValue
                ]
            )
        }
    }

    /// MatStyle 群を ComboPart<FrameSlot> に変換
    static var matComboParts: [ComboPart<FrameSlot>] {
        mats.map { mat in
            ComboPart(
                id: mat.id,
                slot: .mat,
                name: mat.name,
                meta: [
                    "materialID": mat.materialID,
                    "category": mat.category.rawValue,
                    "packID": mat.packID.rawValue
                ]
            )
        }
    }

    /// InnerFrameStyle 群を ComboPart<FrameSlot> に変換
    static var innerComboParts: [ComboPart<FrameSlot>] {
        inners.map { inner in
            ComboPart(
                id: inner.id,
                slot: .inner,
                name: inner.name,
                meta: [
                    "materialID": inner.materialID,
                    "category": inner.category.rawValue,
                    "packID": inner.packID.rawValue
                ]
            )
        }
    }
}
