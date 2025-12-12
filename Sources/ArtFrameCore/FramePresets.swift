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
            materialID: "mat-wood-kumiko"
        ),
        .init(
            id: "outer-modern-black",
            packID: .initial,
            category: .modern,
            name: "Modern Black",
            width: 0.08,
            depth: 0.03,
            materialID: "metal-anodized-black"
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
            materialID: "metal-gold-thin"
        ),
        .init(
            id: "inner-round",
            packID: .initial,
            category: .shape,
            name: "Round",
            width: 0.025,
            materialID: "coating-round"
        ),
        .init(
            id: "inner-sharp",
            packID: .initial,
            category: .shape,
            name: "Sharp",
            width: 0.02,
            materialID: "coating-sharp"
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
