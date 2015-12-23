//
//  CameraUtil.swift
//  DozeDrivingPrevention
//
//  Created by 小林和宏 on 12/1/15.
//  Copyright © 2015 mycompany. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CameraUtil {
    
    // transform from sampleBuffer to UIImage
    class func imageFromSampleBuffer(sampleBuffer: CMSampleBufferRef) -> UIImage {
        let imageBuffer: CVImageBufferRef! = CMSampleBufferGetImageBuffer(sampleBuffer)
        
        // Lock the base address
        CVPixelBufferLockBaseAddress(imageBuffer, 0)
        
        // get image data info
        let baseAddress: UnsafeMutablePointer<Void> = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0)
        
        let bytesPerRow: Int = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width: Int = CVPixelBufferGetWidth(imageBuffer)
        let height: Int = CVPixelBufferGetHeight(imageBuffer)
        
        // create RGB color space
        let colorSpace: CGColorSpaceRef! = CGColorSpaceCreateDeviceRGB()
        
        // create Bitmap graphic context
        let bitsPerCompornent: Int = 8
        let bitmapInfo = CGBitmapInfo(rawValue: (CGBitmapInfo.ByteOrder32Little.rawValue | CGImageAlphaInfo.PremultipliedFirst.rawValue) as UInt32)
        let newContext: CGContextRef! = CGBitmapContextCreate(baseAddress, width, height, bitsPerCompornent, bytesPerRow, colorSpace, bitmapInfo.rawValue) as CGContextRef!
        
        // create Quartz image
        let imageRef: CGImageRef! = CGBitmapContextCreateImage(newContext!)
        
        // Unlock the base address
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0)
        
        // Create UIImage
        let resultImage: UIImage = UIImage(CGImage: imageRef)
        
        return resultImage
    }
    
}