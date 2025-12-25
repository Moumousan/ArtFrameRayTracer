//
//  ArtFrameOptions.swift
//  ArtFrameUI
//
//  Created by SNI on 2025/12/13.
//


// Sources/ArtFrameUI/ArtFrameOptions.swift

import SwiftUI

public struct ArtFrameOptions: Sendable {
    /// 真鍮プレート（タイトルプレート）を表示するかどうか
    public var showsBrassPlate: Bool
    
    /// 将来の Mat 領域のコマンドバー（MBG）を表示するかどうか
    public var showsMatCommandBar: Bool
    
    /// フレーム内側のコンテンツの余白
    public var innerPadding: EdgeInsets
    
    public init(
        showsBrassPlate: Bool = false,
        showsMatCommandBar: Bool = false,
        innerPadding: EdgeInsets = EdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 24)
    ) {
        self.showsBrassPlate = showsBrassPlate
        self.showsMatCommandBar = showsMatCommandBar
        self.innerPadding = innerPadding
    }
    
    /// もっともシンプルな「枠だけ」表示
    public static let minimal = ArtFrameOptions()
    
    /// フォトフレーム向けの標準値（プレートあり）
    public static let photoDefault = ArtFrameOptions(
        showsBrassPlate: true,
        showsMatCommandBar: false,
        innerPadding: EdgeInsets(top: 32, leading: 32, bottom: 32, trailing: 32)
    )
    
    /// Terminal 向け（プレート＋Matバーあり） ※あとで使う
    public static let terminalDefault = ArtFrameOptions(
        showsBrassPlate: true,
        showsMatCommandBar: true,
        innerPadding: EdgeInsets(top: 40, leading: 32, bottom: 32, trailing: 32)
    )
}