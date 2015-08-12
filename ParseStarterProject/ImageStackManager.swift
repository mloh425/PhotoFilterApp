////
////  ImageStackManager.swift
////  ParseStarterProject
////
////  Created by Sau Chung Loh on 8/11/15.
////  Copyright (c) 2015 Parse. All rights reserved.
////
//
//import UIKit
//
//class ImageStackManager { //Using ints for an example
//  private var imageStack = [UIImage]()
//  //Adds a value to the end of the queue
//  func pop (image : UIImage) {
//    if intQueue.isEmpty {
//      intQueue.append(image)
//    } else {
//      intQueue.insert(integer, atIndex: 0)
//    }
//  }
//  
//  //Removes a value from the head of the queue
//  func dequeue () -> Int? {
//    if !intQueue.isEmpty {
//      return intQueue.removeLast()
//    }
//    return nil
//  }
//  
//  //Returns the value of the element at the head of the queue
//  func peek () -> Int? {
//    if !intQueue.isEmpty {
//      var value = intQueue.removeLast()
//      intQueue.append(value)
//      return value
//    }
//    return nil
//  }
//  
//  func isEmpty() -> Bool {
//    if intQueue.isEmpty {
//      return true
//    }
//    return false
//  }
//  
//  func removeAll() -> [Int] {
//    intQueue = []
//    return intQueue
//  }
//  
//  func printQueue() {
//    println(intQueue)
//  }
//}
