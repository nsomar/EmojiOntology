//
//  CSVConvertible.swift
//  EmojiOntology
//
//  Created by Omar Abdelhafith on 27/02/2016.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//

import Foundation

/**
 Protocol to convert objects to CSV
 */
protocol CSVConvertible {
  
  /**
   Return the CSV string for the object
   */
  func toCSVString() -> String
}


extension Emoji: CSVConvertible {
  
  /**
   Converts an emoji to a CSV string
   */
  func toCSVString() -> String {
    let propertiesCSV = self.properties.toCSVString()
    let annotationCSV = self.annotations.toCSVString()
    
    return "\(propertiesCSV),\(annotationCSV)"
  }
  
}

//MARK: - Array Extension

/**
 Array type extension to convert an array of OWL properties to a CSV string
 */
extension _ArrayType where Generator.Element == OWLProperty {
  
  /**
   Convert an array of OWL properties to CSV string
   */
  func toCSVString() -> String {
    return self.map { element in
      return element.value
    }.joinWithSeparator(",")
  }
  
}

/**
 Array type extension to convert an array of annotations to a CSV string
 */
extension _ArrayType where Generator.Element == Annotation {
  
  /**
   Convert an array of annotations to CSV string
   */
  func toCSVString() -> String {
    return self.map { element in
      return element.annotation
      }.joinWithSeparator("; ")
  }
  
}