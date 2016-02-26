//
//  FileReader.swift
//  EmojiOntology
//
//  Created by Omar Abdelhafith on 11/04/2016.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//

import Foundation
import SwiftCSV

/**
 Class responsible to read a CSV file and return a CSV object.
 This CSV object will have convenience method to read the rows and columns.
 */
class CSVReader {
  
  /**
   Read a CSV file and convert it to CSV object
   
   - parameter file: emoji CSV input file
   */
  class func reacCSVFile(file: String) -> CSV? {
    return pathForFile(file) |> readFile
  }
  
  //MARK: - Privates
  
  private class func pathForFile(file: String) -> String? {
    return NSBundle(forClass: self).pathForResource(file, ofType: "csv")
  }

  private class func readFile(file: String) -> CSV? {
    return try? CSV(name: file)
  }
  
}
