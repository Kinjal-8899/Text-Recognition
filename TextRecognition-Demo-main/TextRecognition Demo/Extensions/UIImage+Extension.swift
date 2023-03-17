//
//  UIImage+Extension.swift
//  Scan Characters Demo
//
//  Created by Harindra Pittalia on 08/03/22.
//

import UIKit
import AVFoundation

extension UIImage {

    convenience init?(sampleBuffer: CMSampleBuffer, orientation: UIImage.Orientation = .upMirrored) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        guard let context = CGContext(data: baseAddress, width: width, height: height,
                                      bitsPerComponent: 8, bytesPerRow: bytesPerRow,
                                      space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else { return nil }

        guard let cgImage = context.makeImage() else { return nil }
        self.init(cgImage: cgImage, scale: 1, orientation: orientation)
    }
}
