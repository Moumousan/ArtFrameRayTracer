//
//  LightingPreset.swift
//  ArtFrameRayTracerUnit
//
//  Created by SNI on 2025/12/10.
//


// Sources/ArtFrameRayTracer/Lighting.swift

import simd
import ArtFrameCore

public enum LightingPreset: String, CaseIterable {
    case montblancLeftTop   // 左上モンブラン
    case top                // 真上
    case rightTop           // 右上
    case bottom             // 真下
    case centerSpot         // 中央スポット

    public var displayName: String {
        switch self {
        case .montblancLeftTop: return "Left Top (Montblanc)"
        case .top: return "Top"
        case .rightTop: return "Right Top"
        case .bottom: return "Bottom"
        case .centerSpot: return "Center Spot"
        }
    }

    public var config: LightingConfig {
        switch self {
        case .montblancLeftTop:
            return LightingConfig(
                presetID: rawValue,
                keyLightDirection: normalize(SIMD3(-0.5, -0.7, 1.0)),
                keyLightIntensity: 1.0,
                ambientIntensity: 0.2
            )
        case .top:
            return LightingConfig(
                presetID: rawValue,
                keyLightDirection: normalize(SIMD3(0.0, -1.0, 1.0)),
                keyLightIntensity: 1.0,
                ambientIntensity: 0.3
            )
        case .rightTop:
            return LightingConfig(
                presetID: rawValue,
                keyLightDirection: normalize(SIMD3(0.6, -0.7, 1.0)),
                keyLightIntensity: 1.0,
                ambientIntensity: 0.2
            )
        case .bottom:
            return LightingConfig(
                presetID: rawValue,
                keyLightDirection: normalize(SIMD3(0.0, 1.0, 1.0)),
                keyLightIntensity: 0.9,
                ambientIntensity: 0.25
            )
        case .centerSpot:
            return LightingConfig(
                presetID: rawValue,
                keyLightDirection: normalize(SIMD3(0.0, 0.0, 1.0)),
                keyLightIntensity: 1.2,
                ambientIntensity: 0.1
            )
        }
    }
}