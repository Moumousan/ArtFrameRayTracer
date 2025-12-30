//
//  JoinMode.swift
//  ArtFrameUI
//

import Foundation
import ModernButtonKit2

public enum JoinMode: String, CaseIterable, Identifiable, Hashable, SelectableModeProtocol {
    case butt     // 直交で突き当て
    case miter45  // 45度でカットして接合

    public var id: String {
        switch self {
        case .butt:    return "Butt (90°)"
        case .miter45: return "Miter (45°)"
        }
    }

    // 日本語ラベルが良ければこちらを使ってもOK
    public var displayName: String {
        switch self {
        case .butt:    return "直交（90°）"
        case .miter45: return "留め（45°）"
        }
    }

    public static var uiModes: [JoinMode] { [.butt, .miter45] }
}
