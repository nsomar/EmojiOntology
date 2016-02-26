//
//  CSVGenerator.swift
//  EmojiOntology
//
//  Created by Omar Abdelhafith on 27/02/2016.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//

import Foundation

/**
 Class responsible to generate a CSV string.
 
 This class takes
 
 - a list of Emoji Properties (Color, Sentiment, etc..)
 - a list of Emoji annotations 
 - and a list of emojis
 
 It uses the parameters above to create a csv file that contains all that info.
 */
public class CSVGenerator {
  
  /**
   Generate CSV string for the given emojis, annotations and properties
   
   - parameter properties: Emoji properties to export to CSV
   
   - parameter annotations: Annotations to export to CSV
   
   - paramter emojis: Emojis list to export to CSV
   */
  public class func generateCSV(properties properties: [OWLProperty], annotations: [Annotation], emojis: [Emoji]) -> String {
    
    var properties = properties.map { $0.name }.map { $0.stringByReplacingOccurrencesOfString("has", withString: "") }
    
    properties.append("Annotations")
    properties.append("Color")
    
    let propertyDescriptor = properties.joinWithSeparator(",")
    let emojisCSV = emojis.map { emoji in
      emoji.toCSVString() + "," + emoji.color
    }.joinWithSeparator("\n")
    

    return [propertyDescriptor,
    emojisCSV].joinWithSeparator("\n")
    
  }
  
}