//
//  ImageViewController.swift
//  Cat VS Dog
//
//  Created by Garima Bothra on 05/05/20.
//  Copyright © 2020 Garima Bothra. All rights reserved.
//

import UIKit
import CoreML

class ImageViewController: UIViewController {
    //Create outlets
    @IBOutlet weak var previewImageView: UIImageView!
    //Create variables
    var previewImage: UIImage!
    var model = classifier()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        getModelPrediction()
        // Do any additional setup after loading the view.
    }
    
    func setupImageView() {
        self.previewImageView.image = previewImage
    }

    func getModelPrediction() {
        let input = previewImage.pixelBuffer()

        print(input)
        let inputClassify = classifierInput(image: input!)
        classifier.init()
        do {
        try model.prediction(input: inputClassify, options: MLPredictionOptions())
        } catch {
            print(error)
        }
        let prediction = try? model.prediction(image: input!)
        
        print(prediction?.classLabel)
        print(prediction?.output)


    }

    func getCVPixelBuffer(_ image: CGImage) -> CVPixelBuffer? {
        let imageWidth = 64
        let imageHeight = 64

        let attributes : [NSObject:AnyObject] = [
            kCVPixelBufferCGImageCompatibilityKey : true as AnyObject,
            kCVPixelBufferCGBitmapContextCompatibilityKey : true as AnyObject
        ]

        var pxbuffer: CVPixelBuffer? = nil
        CVPixelBufferCreate(kCFAllocatorDefault,
                            imageWidth,
                            imageHeight,
                            kCVPixelFormatType_32ARGB,
                            attributes as CFDictionary?,
                            &pxbuffer)

        if let _pxbuffer = pxbuffer {
            let flags = CVPixelBufferLockFlags(rawValue: 0)
            CVPixelBufferLockBaseAddress(_pxbuffer, flags)
            let pxdata = CVPixelBufferGetBaseAddress(_pxbuffer)

            let rgbColorSpace = CGColorSpaceCreateDeviceRGB();
            let context = CGContext(data: pxdata,
                                    width: imageWidth,
                                    height: imageHeight,
                                    bitsPerComponent: 8,
                                    bytesPerRow: CVPixelBufferGetBytesPerRow(_pxbuffer),
                                    space: rgbColorSpace,
                                    bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)

            if let _context = context {
                _context.draw(image, in: CGRect.init(x: 0, y: 0, width: imageWidth, height: imageHeight))
            }
            else {
                CVPixelBufferUnlockBaseAddress(_pxbuffer, flags);
                return nil
            }

            CVPixelBufferUnlockBaseAddress(_pxbuffer, flags);
            return _pxbuffer;
        }

        return nil
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
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
