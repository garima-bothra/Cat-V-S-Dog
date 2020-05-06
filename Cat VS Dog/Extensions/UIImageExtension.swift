//
//  UIImageExtension.swift
//  Cat VS Dog
//
//  Created by Garima Bothra on 06/05/20.
//  Copyright © 2020 Garima Bothra. All rights reserved.
//

import Foundation
import UIKit

//Extension to create pixel buffer to get model input type
extension UIImage {

    func pixelBuffer() -> CVPixelBuffer? {
// NOTE: Create pixel buffer with specified pixel format
var pixelBuffer: CVPixelBuffer?
let options = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
let status = CVPixelBufferCreate(kCFAllocatorDefault, 64, 64, kCVPixelFormatType_32ARGB, options, &pixelBuffer)
guard status == kCVReturnSuccess, let finalPixelBuffer = pixelBuffer else {
    return nil
}
        // NOTE: Create context ("canvas") for drawing pixels
               CVPixelBufferLockBaseAddress(finalPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
               let pixelData = CVPixelBufferGetBaseAddress(finalPixelBuffer)
               let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
               guard let context = CGContext(data: pixelData, width: Int(64), height: 64, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(finalPixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
                   return nil
               }
               context.translateBy(x: 0, y: 64)
               context.scaleBy(x: 1.0, y: -1.0)

               // NOTE: Draw pixels on the context, updates pixel buffer
               UIGraphicsPushContext(context)
               draw(in: CGRect(x: 0, y: 0, width: 64, height: 64))
               UIGraphicsPopContext()
               CVPixelBufferUnlockBaseAddress(finalPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

               return finalPixelBuffer
}
}
