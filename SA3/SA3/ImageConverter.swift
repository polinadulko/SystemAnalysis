//
//  ImageGrayscaleConverter.swift
//  SA3
//
//  Created by Polina Dulko on 3/23/19.
//  Copyright © 2019 Polina Dulko. All rights reserved.
//

import Cocoa
import Accelerate

class ImageConverter {
    
    var image: CGImage?
    let redCoefficient: Float = 0.2126
    let greenCoefficient: Float = 0.7152
    let blueCoefficient: Float = 0.0722
    
    init(sourceImage: NSImage) {
        var rect = CGRect(x: 0, y: 0, width: sourceImage.size.width, height: sourceImage.size.height)
        image =  sourceImage.cgImage(forProposedRect: &rect, context: nil, hints: nil)
    }
    
    lazy var format: vImage_CGImageFormat = {
        guard let sourceImage = image else {
            fatalError("Unable to get image")
        }
        guard let colorSpace = sourceImage.colorSpace else {
            fatalError("Unable to get color space")
        }
        return vImage_CGImageFormat(bitsPerComponent: UInt32(sourceImage.bitsPerComponent), bitsPerPixel: UInt32(sourceImage.bitsPerPixel), colorSpace: Unmanaged.passRetained(colorSpace), bitmapInfo: sourceImage.bitmapInfo, version: 0, decode: nil, renderingIntent: sourceImage.renderingIntent)
    }()
    
    lazy var sourceBuffer: vImage_Buffer = {
        guard let sourceImage = image else {
            fatalError("Unable to get image")
        }
        var sourceImageBuffer = vImage_Buffer()
        vImageBuffer_InitWithCGImage(&sourceImageBuffer, &format, nil, sourceImage, vImage_Flags(kvImageNoFlags))
        var scaledBuffer = vImage_Buffer()
        vImageBuffer_Init(&scaledBuffer, sourceImageBuffer.height, sourceImageBuffer.width, format.bitsPerPixel, vImage_Flags(kvImageNoFlags))
        vImageScale_ARGB8888(&sourceImageBuffer, &scaledBuffer, nil, vImage_Flags(kvImageNoFlags))
        return scaledBuffer
    }()
    
    lazy var destinationBuffer: vImage_Buffer = {
        var destinationBuffer = vImage_Buffer()
        vImageBuffer_Init(&destinationBuffer, sourceBuffer.height, sourceBuffer.width, 8, vImage_Flags(kvImageNoFlags))
        return destinationBuffer
    }()
    
    func convertToGrayscale() -> CGImage? {
        let divisor: Int32 = 0x1000
        let fDivisor = Float(divisor)
        var coefficientsMatrix = [Int16(redCoefficient * fDivisor), Int16(greenCoefficient * fDivisor), Int16(blueCoefficient * fDivisor)]
        let preBias: [Int16] = [0, 0, 0, 0]
        let postBias: Int32 = 0
        vImageMatrixMultiply_ARGB8888ToPlanar8(&sourceBuffer, &destinationBuffer, &coefficientsMatrix, divisor, preBias, postBias, vImage_Flags(kvImageNoFlags))
        var grayscaleFormat = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 8, colorSpace: Unmanaged.passRetained(CGColorSpaceCreateDeviceGray()), bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue), version: 0, decode: nil, renderingIntent: .defaultIntent)
        return vImageCreateCGImageFromBuffer(&destinationBuffer, &grayscaleFormat, nil, nil, vImage_Flags(kvImageNoFlags), nil)?.takeRetainedValue()
    }
    
}
