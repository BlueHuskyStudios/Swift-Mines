//
//  CGImage Conveniences.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-05-25.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import Foundation
import DrawingTools
import CoreGraphics



public extension CGImage {
    static func new(
        size: CGSize,
        bitsPerComponent: UInt8 = 8,
        componentsPerPixel: UInt8 = 4,
        colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGBitmapInfo = [.alphaInfoMask],
        data: CFData? = nil,
        shouldInterpolate: Bool = true,
        colorRenderingIntent: CGColorRenderingIntent = .defaultIntent
    ) -> CGImage?
    {
        let width = Int(size.width)
        let height = Int(size.height)
        let bitsPerComponent = Int(bitsPerComponent)
        let componentsPerPixel = Int(componentsPerPixel)
        let bitsPerPixel = bitsPerComponent * componentsPerPixel
        let bytesPerRow = width * bitsPerPixel * 8
        let data = data ?? (Data(repeating: 0, count: bytesPerRow * height) as CFData)
        
        guard let dataProvider = CGDataProvider(data: data) else { return nil }
        
        return CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: bitmapInfo,
            provider: dataProvider,
            decode: nil,
            shouldInterpolate: shouldInterpolate,
            intent: colorRenderingIntent
        )
    }
}
