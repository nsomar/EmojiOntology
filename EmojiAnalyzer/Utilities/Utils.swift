//
//  Utils.swift
//  EmojiOntology
//
//  Created by Omar Abdelhafith on 27/02/2016.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//

import Foundation


/**
 Perform an operation on the main thread
 */
func onMain(callback: () -> ()) {
  dispatch_async(dispatch_get_main_queue()) {
    callback()
  }
}


/**
 Perform an operation in a background thread
 */
func onBackground(callback: () -> ()) {
  let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
  dispatch_async(dispatch_get_global_queue(priority, 0)) {
    callback()
  }
}


/**
 Perform an operation after a given time
 
 - paramter delay: delay time to perform operation
 */
func after(delay: Double, callback: () -> ()) {
  let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
  
  dispatch_after(delayTime, dispatch_get_main_queue()) {
    callback()
  }
}