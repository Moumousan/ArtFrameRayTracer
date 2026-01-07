//  Color+ArtFrame.swift
//  ArtFrameUI
//

import SwiftUI

public extension Color {

    /// サムネイルカードなど、アートフレーム系UIで使う標準背景色
    static var artFrameCardBackground: Color {
        #if os(macOS)
        Color(nsColor: .windowBackgroundColor)
        #elseif os(iOS) || os(tvOS) || os(visionOS)
        Color(uiColor: .secondarySystemBackground)
        #else
        Color.gray.opacity(0.1)
        #endif
    }

    /// もし他にも共通色が増えたらここに足していく
    // static var artFrameAccent: Color { ... }
}