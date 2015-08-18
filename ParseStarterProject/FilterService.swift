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
  
  static let context = CIContext(options: nil)
  
  class func filterProcess(filter: CIFilter) -> UIImage? {
//    let context = CIContext(options: nil) // CPU Context, not as fast -> Try not to recreate
    //GPU Context
    let options = [kCIContextWorkingColorSpace : NSNull()] //less quality, but better performance
    let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
    let gpuContext = CIContext(EAGLContext: eaglContext, options: options)
    
    let outputImage = filter.outputImage
    let extent = outputImage.extent()
    
    let cgImage = gpuContext.createCGImage(outputImage, fromRect: extent)
    let finalImage = UIImage(CGImage: cgImage)
    if let finalImage = UIImage(CGImage: cgImage) {
      return finalImage
    }
    return nil
  }
  
 //Mark: Set up of different Filters
  class func sepiaImageFromOriginalImage(original : UIImage) -> UIImage? {
    let image = CIImage(image: original)
    let sepiaFilter = CIFilter(name: "CISepiaTone")
    sepiaFilter.setValue(image, forKey: kCIInputImageKey)
    let processedImage = FilterService.filterProcess(sepiaFilter)
    return processedImage
  }
  
  class func noirImageFromOriginalImage(original : UIImage) -> UIImage? {
    let image = CIImage(image: original)
    let noirFilter = CIFilter(name: "CIPhotoEffectNoir")
    noirFilter.setValue(image, forKey: kCIInputImageKey)
    let processedImage = FilterService.filterProcess(noirFilter)
    return processedImage
  }
  
  class func chromeImageFromOriginalImage(original : UIImage) -> UIImage? {
    let image = CIImage(image: original)
    let chromeFilter = CIFilter(name: "CIPhotoEffectChrome")
    chromeFilter.setValue(image, forKey: kCIInputImageKey)
    let processedImage = FilterService.filterProcess(chromeFilter)
    return processedImage
  }
  
  class func bloomImageFromOriginalImage(original : UIImage) -> UIImage? {
    let image = CIImage(image: original)
    let bloomFilter = CIFilter(name: "CIBloom")
    bloomFilter.setValue(image, forKey: kCIInputImageKey)
    let processedImage = FilterService.filterProcess(bloomFilter)
    return processedImage
  }
  
  //Chained filter, instant then fade.
  class func instantFadeImageFromOriginalImage(original : UIImage) -> UIImage? {
    let imageInstant = CIImage(image: original)
    let instantFilter = CIFilter(name: "CIPhotoEffectInstant")
    instantFilter.setValue(imageInstant, forKey: kCIInputImageKey)
    let processedImage1 = FilterService.filterProcess(instantFilter)
    
    let imageFade = CIImage(image: processedImage1)
    let fadeFilter = CIFilter(name: "CIPhotoEffectFade")
    fadeFilter.setValue(imageFade, forKey: kCIInputImageKey)
    let processedImage2 = FilterService.filterProcess(fadeFilter)
    return processedImage2
  }
}
