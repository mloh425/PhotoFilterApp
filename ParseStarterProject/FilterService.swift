//
//  FilterService.swift
//  ParseStarterProject
//
//  Created by Sau Chung Loh on 8/11/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class FilterService {
  class func filterProcess(filter: CIFilter) -> UIImage? {
    //CPU Context ,not fast like GPU
    let context = CIContext(options: nil) // CPU Context, not as fast -> Try not to recreate
    
    //GPU Context
    let options = [kCIContextWorkingColorSpace : NSNull()] //less quality, but better performance
    let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
    let gputContext = CIContext(EAGLContext: eaglContext, options: options)
    
    let outputImage = filter.outputImage
    let extent = outputImage.extent()
    
    let cgImage = context.createCGImage(outputImage, fromRect: extent)
    let finalImage = UIImage(CGImage: cgImage)
    if let finalImage = UIImage(CGImage: cgImage) {
      return finalImage
    }
    return nil
  }
  
 // class func sepiaImageFromOriginalImage(original : UIImage, context : CIContext) -> UIImage? {
  class func sepiaImageFromOriginalImage(original : UIImage) -> UIImage? {
    let image = CIImage(image: original)
    let sepiaFilter = CIFilter(name: "CISepiaTone")
    sepiaFilter.setValue(image, forKey: kCIInputImageKey)
    let processedImage = FilterService.filterProcess(sepiaFilter)
    return processedImage
  }
//  
//  class func sepiaImageFromOriginalImage(original : UIImage) -> UIImage? {
//    let image = CIImage(image: original)
//    let sepiaFilter = CIFilter(name: "CISepiaTone")
//    sepiaFilter.setValue(image, forKey: kCIInputImageKey)
//    let processedImage = FilterService.filterProcess(sepiaFilter)
//    return processedImage
//  }
//  
//  class func sepiaImageFromOriginalImage(original : UIImage) -> UIImage? {
//    let image = CIImage(image: original)
//    let sepiaFilter = CIFilter(name: "CISepiaTone")
//    sepiaFilter.setValue(image, forKey: kCIInputImageKey)
//    let processedImage = FilterService.filterProcess(sepiaFilter)
//    return processedImage
//  }
//  
//  class func sepiaImageFromOriginalImage(original : UIImage) -> UIImage? {
//    let image = CIImage(image: original)
//    let sepiaFilter = CIFilter(name: "CISepiaTone")
//    sepiaFilter.setValue(image, forKey: kCIInputImageKey)
//    let processedImage = FilterService.filterProcess(sepiaFilter)
//    return processedImage
//  }
}
