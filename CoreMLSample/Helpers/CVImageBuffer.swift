//
//  CVImageBuffer.swift
//  CoreMLSample
//
//  Created by Bruno Rocha on 6/9/17.
//  Copyright © 2017 Bruno Rocha. All rights reserved.
//

import UIKit
import AVFoundation

extension CVImageBuffer {
    func toImage() -> UIImage {

        CVPixelBufferLockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
        let baseAddress = CVPixelBufferGetBaseAddress(self)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(self)
        let width = CVPixelBufferGetWidth(self)
        let height = CVPixelBufferGetHeight(self)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        let ref = context!.makeImage()
        CVPixelBufferUnlockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))

        return UIImage(cgImage: ref!)
    }
}
