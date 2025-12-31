//
//  MatBuildMode.swift（
//  ArtFramePartsStudio
//
//  Created by SNI on 2025/12/25.
//
// MatBuildMode.swift（ArtFrameUI モジュール側に置くのが自然です）
import Foundation
import ModernButtonKit2

public enum MatBuildMode: String, CaseIterable, Identifiable, Hashable, SelectableModeProtocol {
    case sheetCutout   // 台紙1枚をくり抜く（輪っか）
    case stripJoined   // 4本の帯で構成（Joinの影響を受ける）

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .sheetCutout: return "Sheet"
        case .stripJoined: return "Strips"
        }
    }

    public static var uiModes: [MatBuildMode] { [.sheetCutout, .stripJoined] }
}
