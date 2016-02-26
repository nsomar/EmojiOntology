//
//  Pipe.swift
//  DublinBusMenu
//
//  Created by Omar Abdelhafith on 01/02/2016.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//

import Foundation

infix operator |> {
associativity left
precedence 100
}

infix operator |>> {
associativity left
precedence 100
}


/**
 Pipe operator (Apply)
 
 used as fa: A -> B. fb B -> C. 
 fa |> fb.
 A -> B -> C. A -> C
 */
public func |> <T> (left: T?, right: T -> ()) {
  guard let left = left else { return }
  return right(left)
}

/**
 Pipe operator (Apply)
 
 used as fa: A -> B. fb B -> C.
 fa |> fb.
 A -> B -> C. A -> C
 */
public func |> <T, W> (left: T?, right: T -> W?) -> W? {
  guard let left = left else { return nil }
  return right(left)
}

/**
 Pipe operator (Apply)
 
 used as fa: A -> B. fb B -> C.
 fa |> fb.
 A -> B -> C. A -> C
 */
public func |> <T, W> (left: T, right: T -> W) -> W {
  return right(left)
}

/**
 Asynchronous pipe
 
 Callback = (T? -> ())
 Async function = ((T? -> ()) -> ())? => (Callback -> ())?
 Left: Maybe an async function
 Right: T -> W?, map function
 */
public func |>> <T, W> (left: ((T? -> ()) -> ())?, right: T -> W?) -> W? {

  guard let left = left else { return nil }

  left { leftVal in
    guard let leftVal = leftVal else { return }
    right(leftVal)
  }

  return nil
}
