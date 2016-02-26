//
//  Annotation.swift
//  EmojiOntology
//
//  Created by Omar Abdelhafith on 25/02/2016.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//

import Foundation

/**
 Annotation class representing an emoji annotation (face, eyes, mouth, etc..)
 */
public class Annotation: Equatable, Hashable {
  
  /**
   Annotation value
   */
  let annotation: String
  
  private var emojis = [Emoji]()
  
  /**
   Create an annotation with a string
   
   - parameter annotation: annotation value
   */
  init(withString annotation: String) {
    self.annotation = annotation
  }
  
  /**
   Create a list of annotations from a comma seperated string
   
   - parameter string: comma sepereted string of annotations
   */
  class func fromString(string: String?) -> [Annotation] {
    guard let string = string else { return [] }
    
    return string.componentsSeparatedByString(";").map {
      $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
      }.map { Annotation(withString: $0) }
  }
  
  /**
   Annotation formal name. This name is used when saving to CSV or OWL
   */
  var name: String {
    return OWLNamer.prepareName(annotation) + "Annotation"
  }
  
  public var hashValue: Int {
    return self.annotation.hashValue
  }
  
}

/**
 Compare two annotations for equality
 */
public func ==(lhs: Annotation, rhs: Annotation) -> Bool {
  return lhs.annotation == rhs.annotation
}