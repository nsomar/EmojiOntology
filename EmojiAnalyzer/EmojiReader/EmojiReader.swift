//
//  EmojiReader.swift
//  EmojiOntology
//
//  Created by Omar Abdelhafith on 25/02/2016.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//

import Foundation
import SwiftCSV

/**
 Class responsible for reading the emoji Unicode CSV and parse it to a list of annotations and emojis.
 */
public class EmojiReader {

  /**
   Read the emoji CSV file and return a list of annotaions and emoji object
   
   - parameter file: emoji CSV input file
   */
  public class func read(file file: String) -> ([Annotation], [Emoji]) {
    var annotationsDict = [String: Annotation]()
    let emojis = readEmoji(file: file)
    
    emojis.flatMap { $0.annotations }.forEach { annotation in
      if annotationsDict[annotation.annotation] == nil {
        annotationsDict[annotation.annotation] = annotation
      }
    }
    
    return (Array(annotationsDict.values), emojis)
  }
  
  /**
   Read the emoji CSV file and return a list of emojis
   
   - parameter file: emoji CSV input file
   */
  public class func readEmoji(file file: String) -> [Emoji] {
    let items = CSVReader.reacCSVFile(file)
      |> { csv in
        return csv.rows |> Emoji.fromArray
      }
  
    return items ?? []
  }
  
}
