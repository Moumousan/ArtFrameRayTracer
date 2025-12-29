//
//  FrameThumbnailCard.swift
//  ArtFrameRayTracer
//
//  Created by SNI on 2025/12/29.
//

import SwiftUI
import ArtFrameCore
import ModernButtonKit2
// ArtFrameUI 側に置いておくと再利用しやすい
public struct FrameThumbnailCard<InfoContent: View>: View {
    public let title: String
    public let size: CGSize

    @ViewBuilder public var preview: () -> AnyView
    @ViewBuilder public var infoContent: () -> InfoContent

    public init(
        title: String,
        size: CGSize = .init(width: 180, height: 180),
        preview: @escaping () -> AnyView,
        @ViewBuilder infoContent: @escaping () -> InfoContent
    ) {
        self.title = title
        self.size = size
        self.preview = preview
        self.infoContent = infoContent
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            // サムネール
            preview()
                .frame(width: size.width, height: size.height)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(nsColor: .windowBackgroundColor))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.secondary.opacity(0.3))
                )

            // 情報エリア
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.05))
                .overlay(
                    infoContent()
                        .padding(8)
                )
                .frame(height: 80)
        }
    }
}
