//
//  FramePartSelectorPanel.swift
//  ArtFrameUI
//
//  Created by SNI on 2025/12/29.
//


// Sources/ArtFrameUI/FramePartSelectorPanel.swift

import SwiftUI
import ArtFrameCore
import ModernButtonKit2
/// Outer / Mat / Inner の 3 スロットを、
/// MBG() のレーンで縦に並べて選択するパネル。
///
/// - 右ペインの簡易プレビューと組み合わせて使う前提。
/// - MatPreviewModel を共有することで、
///   複数ビュー間で選択状態を同期する。
public struct FramePartSelectorPanel: View {

    @ObservedObject  var model: MatPreviewModel

     init(model: MatPreviewModel) {
        self.model = model
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            outerLane       // OUTER
            matLane         // MAT
            innerLane       // INNER
        }
        .padding()
    }

    // MARK: - Individual Lanes

    @ViewBuilder
    private var outerLane: some View {
        Text("Outer")
            .font(.headline)
        // ここで MBG() を使って outerParts を並べる
        // model.selectedOuterMode をバインド
        // OUTER
        VStack(alignment: .leading, spacing: 8) {
            Text("Outer")
                .font(.headline)

            MBG(
                modes: model.outerModes,
                selected: $model.selectedOuterMode,
                layout: .scrollableVertical(rightBarSpacing: MBGDefaults.rightBarSpacing)
            )
            .frame(width: 180, height: 260)
        }
    }

    @ViewBuilder
    private var matLane: some View {
        Text("Mat")
            .font(.headline)
        // 同様に MBG() + model.selectedMatMode
        // MAT
        VStack(alignment: .leading, spacing: 8) {
            Text("Mat")
                .font(.headline)

            MBG(
                modes: model.matModes,
                selected: $model.selectedMatMode,
                layout: .scrollableVertical(rightBarSpacing: MBGDefaults.rightBarSpacing)
            )
            .frame(width: 180, height: 260)
        }
    }

    @ViewBuilder
    private var innerLane: some View {
        Text("Inner")
            .font(.headline)
        // 同様に MBG() + model.selectedInnerMode
        // INNER
        VStack(alignment: .leading, spacing: 8) {
            Text("Inner")
                .font(.headline)

            MBG(
                modes: model.innerModes,
                selected: $model.selectedInnerMode,
                layout: .scrollableVertical(rightBarSpacing: MBGDefaults.rightBarSpacing)
            )
            .frame(width: 180, height: 260)
        }
    }
}

