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

// MARK: - DefaultPacks → ComboPart マッピング

// MARK: - DefaultPacks → FramePart 変換

public extension DefaultPacks {

    /// Outer 用のパーツ群を ComboPart<FrameSlot> に変換
    public static var outerComboParts: [FramePart] {
        outer.map { style in
            ComboPart(
                id: style.id,
                slot: .outer,
                name: style.name,
                meta: [
                    "packID": style.packID.rawValue,
                    "category": style.category.rawValue,
                    "materialID": style.materialID,
                    "sectionProfileID": style.sectionProfileID ?? "",
                    "width": "\(style.width)",
                    "depth": "\(style.depth)"
                ]
            )
        }
    }

    /// Mat 用のパーツ群
    public static var matComboParts: [FramePart] {
        mats.map { style in
            ComboPart(
                id: style.id,
                slot: .mat,
                name: style.name,
                meta: [
                    "packID": style.packID.rawValue,
                    "category": style.category.rawValue,
                    "materialID": style.materialID,
                    "margin": "\(style.margin)"
                ]
            )
        }
    }

    /// Inner 用のパーツ群
    public static var innerComboParts: [FramePart] {
        inners.map { style in
            ComboPart(
                id: style.id,
                slot: .inner,
                name: style.name,
                meta: [
                    "packID": style.packID.rawValue,
                    "category": style.category.rawValue,
                    "materialID": style.materialID,
                    "sectionProfileID": style.sectionProfileID ?? "",
                    "width": "\(style.width)"
                ]
            )
        }
    }
}

public extension DefaultPacks {

    /// スロット別に FramePart をまとめた辞書
    public static var framePartsBySlot: [FrameSlot: [FramePart]] {
        [
            .outer: outerComboParts,
            .mat:   matComboParts,
            .inner: innerComboParts
        ]
    }

    /// v0.x の「標準プリセット全部入り」ライブラリ
    /// - パーツもレシピも両方入った状態で返す
    public static var initialFrameLibrary: FrameLibrary {
        var lib = FrameLibrary(partsBySlot: framePartsBySlot)
        lib.generateAllFrameRecipes()          // ← ここでレシピを自動生成
        return lib
    }
}
