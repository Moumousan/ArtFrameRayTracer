//
//  JoinModePickerView.swift
//  ArtFrameUI
//

import SwiftUI
import ModernButtonKit2

public struct JoinModePickerView: View {
    public let title: String
    @Binding public var selected: JoinMode

    public let themeColor: Color
    public let font: Font
    public let spacing: CGFloat
    public let showTitle: Bool

    public init(
        title: String = "Join Style",
        selected: Binding<JoinMode>,
        themeColor: Color = .accentColor,
        font: Font = .system(size: 12),
        spacing: CGFloat = 8,
        showTitle: Bool = true
    ) {
        self.title = title
        self._selected = selected
        self.themeColor = themeColor
        self.font = font
        self.spacing = spacing
        self.showTitle = showTitle
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if showTitle {
                Text(title)
                    .font(.headline)
            }

            MBGRadioGroup(
                modes: JoinMode.uiModes,
                selected: $selected,
                freeComment: .constant(""),
                themeColor: themeColor,
                showFreeComment: false,
                font: font,
                spacing: spacing
            )
        }
    }
}
