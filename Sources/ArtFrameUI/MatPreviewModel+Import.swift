//
//  MatPreviewModel+Import.swift
//  ArtFrameUI
//

import Foundation
import SwiftUI
import ArtFrameCore

#if os(macOS)
import AppKit
#endif

public extension MatPreviewModel {

    /// ファイルから読み込んだテクスチャを、スロットごとの
    /// 「カスタム画像」として保持する。
    func importTexture(from url: URL, for slot: FrameSlot) {
        #if os(macOS)
        guard let image = NSImage(contentsOf: url) else { return }

        switch slot {
        case .outer:
            customOuterImage = image
        case .mat:
            customMatImage   = image
        case .inner:
            customInnerImage = image
        }
        #endif
    }
}
