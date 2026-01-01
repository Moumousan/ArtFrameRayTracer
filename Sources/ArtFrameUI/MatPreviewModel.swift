//
//  MatPreviewModel.swift
//  ArtFrameUI
//
//  Created by Kyoto Denno Kogei Kobo-sha on 2025/12/26.
//

import SwiftUI
import Combine
import ArtFrameCore

#if os(macOS)
import AppKit
#endif

/// 工房とビューワ（MatViewerView / DemoFrameView など）が共有する状態モデル。
///
/// v0.x では：
/// - Outer / Mat / Inner の厚み
/// - Mat のテクスチャ
/// - Photo
/// - 簡易レイトレ結果
/// - Set A〜E のプリセット
/// を扱う。
///

@MainActor
public final class MatPreviewModel: ObservableObject {
    @Published public var frameLibrary: FrameLibrary = DefaultPacks.initialFrameLibrary
    
    public var outerParts: [FramePart] { frameLibrary.partsBySlot[.outer] ?? [] }
    public var matParts:   [FramePart] { frameLibrary.partsBySlot[.mat]   ?? [] }
    public var innerParts: [FramePart] { frameLibrary.partsBySlot[.inner] ?? [] }
    
    public var outerModes: [FramePartMode] {
        outerParts.map { FramePartMode(slot: .outer, part: $0) }
    }
    
    public var matModes: [FramePartMode] {
        let none = FramePartMode(noneFor: .mat, title: "Choose…")
        return [none] + matParts.map { FramePartMode(slot: .mat, part: $0) }
    }
    
    public var innerModes: [FramePartMode] {
        let none = FramePartMode(noneFor: .inner, title: "Choose…")
        return [none] + innerParts.map { FramePartMode(slot: .inner, part: $0) }
    }
    
    @Published public var selectedOuterMode: FramePartMode
    @Published public var selectedMatMode:   FramePartMode
    @Published public var selectedInnerMode: FramePartMode
    
    public var selectedOuterPart: FramePart? { selectedOuterMode.part }
    public var selectedMatPart:   FramePart? { selectedMatMode.part }
    public var selectedInnerPart: FramePart? { selectedInnerMode.part }
    
    @Published public var outerThickness: CGFloat = 40
    @Published public var matThickness: CGFloat = 80
    @Published public var innerThickness: CGFloat = 8
    
    @Published public var matStyles: [MatTextureStyle] = [
        .init(id: "wood",
              displayName: "Weathered Wood",
              assetName: "MatTextureSample"),
        .init(id: "plain",
              displayName: "Plain Paper",
              assetName: "MatTexturePlain"),
        .init(id: "catPaws",
              displayName: "Cat Paws",
              assetName: "MatTextureCatPaws")
    ]
    
    @Published public var selectedMatStyleID: String = "wood"
    
    public var selectedMatStyle: MatTextureStyle {
        matStyles.first { $0.id == selectedMatStyleID } ?? matStyles[0]
    }
    
    @Published public var editingLane: FrameSlot = .outer
    
    // Join（O/M/I全体に適用）
    @Published public var joinMode: JoinMode = .butt
    
    // Mat の作り方（台紙 or 板材）
    @Published public var matBuildMode: MatBuildMode = .sheetCutout
    
    // Presets
    @Published public var activePreset: FramePresetID = .setA
    @Published public var presets: [FramePresetID: FramePreset] = [:]
    
    private let presetsKey = "MatPreviewModel.presets.v1"
    private let activePresetKey = "MatPreviewModel.activePreset.v1"
    
    public func saveCurrentState(to presetID: FramePresetID) {
        let preset = FramePreset(
            id: presetID,
            outerThickness: outerThickness,
            matThickness: matThickness,
            innerThickness: innerThickness,
            matStyleID: selectedMatStyleID
        )
        presets[presetID] = preset
        persistPresets()
    }
    
    public func loadPreset(_ presetID: FramePresetID) {
        guard let preset = presets[presetID] else { return }
        outerThickness = preset.outerThickness
        matThickness = preset.matThickness
        innerThickness = preset.innerThickness
        selectedMatStyleID = preset.matStyleID
        activePreset = presetID
        persistActivePreset()
    }
    
    public var currentSetDescription: String {
        let preset = presets[activePreset]
        
        let matName: String = {
            if let id = preset?.matStyleID,
               let s = matStyles.first(where: { $0.id == id }) {
                return s.displayName
            }
            return selectedMatStyle.displayName
        }()
        
        let outerText = String(format: "%.0f pt", preset?.outerThickness ?? outerThickness)
        let matText   = String(format: "%.0f pt", preset?.matThickness   ?? matThickness)
        let innerText = String(format: "%.0f pt", preset?.innerThickness ?? innerThickness)
        
        return """
        Outer: \(outerText), Mat: \(matText), Inner: \(innerText)
        Mat Texture: \(matName)
        """
    }
    
#if os(macOS)
    @Published public var photo: NSImage? = nil
    @Published public var raytracedImage: CGImage? = nil
    @Published public var customOuterImage: NSImage?
    @Published public var customMatImage:   NSImage?
    @Published public var customInnerImage: NSImage?
#endif
    
    public init() {
        let lib = DefaultPacks.initialFrameLibrary
        self.frameLibrary = lib
        
        if let firstOuter = lib.partsBySlot[.outer]?.first {
            self.selectedOuterMode = FramePartMode(slot: .outer, part: firstOuter)
        } else {
            self.selectedOuterMode = FramePartMode(noneFor: .outer, title: "—")
        }
        self.selectedMatMode   = FramePartMode(noneFor: .mat,   title: "Choose…")
        self.selectedInnerMode = FramePartMode(noneFor: .inner, title: "Choose…")
        
        // 1) 既存保存を読み込む
        restorePresets()
        restoreActivePreset()
        
        // 2) 何も無ければ初期プリセットを用意
        if presets.isEmpty {
            let initial = FramePreset(
                id: .setA,
                outerThickness: outerThickness,
                matThickness: matThickness,
                innerThickness: innerThickness,
                matStyleID: selectedMatStyleID
            )
            self.presets = [.setA: initial]
            self.activePreset = .setA
            persistPresets()
            persistActivePreset()
        }
        
        // 3) アクティブセットが存在すれば内容を反映
        if let preset = presets[activePreset] {
            outerThickness = preset.outerThickness
            matThickness = preset.matThickness
            innerThickness = preset.innerThickness
            selectedMatStyleID = preset.matStyleID
        }
    }
    
#if os(macOS)
    public func renderWithRayTracer(targetSize: CGSize) {
        let width  = Int(targetSize.width)
        let height = Int(targetSize.height)
        
        guard let ctx = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            raytracedImage = nil
            return
        }
        
        let rect = CGRect(origin: .zero, size: targetSize)
        ctx.setFillColor(CGColor(gray: 0.10, alpha: 1.0))
        ctx.fill(rect)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors: [CGColor] = [
            CGColor(gray: 0.85, alpha: 1.0),
            CGColor(gray: 0.20, alpha: 1.0)
        ]
        _ = colorSpace
        _ = colors
    }
#endif
    
    // MARK: - Persistence
    private func persistPresets() {
        do {
            let dict = Dictionary(uniqueKeysWithValues: presets.map { ($0.key.rawValue, $0.value) })
            let data = try JSONEncoder().encode(dict)
            UserDefaults.standard.set(data, forKey: presetsKey)
        } catch {
            // 必要に応じてログ
            // print("Failed to save presets: \(error)")
        }
    }
    
    private func restorePresets() {
        guard let data = UserDefaults.standard.data(forKey: presetsKey) else { return }
        do {
            let decoded = try JSONDecoder().decode([String: FramePreset].self, from: data)
            var mapped: [FramePresetID: FramePreset] = [:]
            for (key, preset) in decoded {
                if let id = FramePresetID(rawValue: key) {
                    mapped[id] = preset
                }
            }
            self.presets = mapped
        } catch {
            // print("Failed to load presets: \(error)")
        }
    }
    
    private func persistActivePreset() {
        UserDefaults.standard.set(activePreset.rawValue, forKey: activePresetKey)
    }
    
    private func restoreActivePreset() {
        if let raw = UserDefaults.standard.string(forKey: activePresetKey),
           let id = FramePresetID(rawValue: raw) {
            self.activePreset = id
        }
    }
}

