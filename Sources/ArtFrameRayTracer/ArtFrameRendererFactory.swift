//
//  ArtFrameRendererFactory.swift
//  ArtFrameRayTracer
//
//  Created by SNI on 2025/12/12.
//


import ArtFrameCore
import ArtFrameRayTracerCPU
import ArtFrameRayTracerMetal

public enum ArtFrameRendererFactory {

    public static func make(
        preferred backend: RendererBackend = .auto
    ) -> any ArtFrameRenderer {

        switch backend {
        case .cpu:
            return CPURayTracerRenderer()

        case .metal:
            if let metal = MetalRayTracerRenderer() {
                return metal
            } else {
                return CPURayTracerRenderer()
            }

        case .auto:
            #if os(iOS)
            if let metal = MetalRayTracerRenderer() {
                return metal
            } else {
                return CPURayTracerRenderer()
            }
            #else
            return CPURayTracerRenderer()
            #endif
        }
    }
}