//
//  ImageResizer.swift
//  ParseStarterProject
//
//  Created by Sau Chung Loh on 8/12/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//


import UIKit

class ImageResizer {
  class func resizeImage(image : UIImage, size : CGSize) -> UIImage {
    UIGraphicsBeginImageContext(size)
    image.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return resizedImage
  }
  
  class func determineImageSizeToDisplay() -> CGSize {
    var size : CGSize
    switch UIScreen.mainScreen().scale {
    case 2:
      size = CGSize(width: 1200, height: 1200)
    case 3:
      size = CGSize(width: 1800, height: 1800)
    default:
      size = CGSize(width: 600, height: 600)
    }
    return size
  }
}

