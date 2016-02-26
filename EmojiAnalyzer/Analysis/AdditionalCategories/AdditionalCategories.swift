//
//  AdditionalCategories.swift
//  EmojiOntology
//
//  Created by Omar Abdelhafith on 11/04/2016.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//

import Foundation
import SwiftCSV


/**
 Class responsible to parse and enrich the emoji annotations with additional structural levels
 */
class AdditionalCategories {
  
  /**
   Read the stored CSV file and its textual contents.
   Return a string that represents an OWL/XML representation of the additional categories. 
   This string is filled into final OWL emoji template file.
   
   - parameter file: file path
   */
  class func read(file file: String) -> String {
    guard let csvFile = CSVReader.reacCSVFile(file) else {
      return ""
    }
    
    let subcclasses = csvFile.rows.flatMap(parseRow).joinWithSeparator("\n")
    return subcclasses
  }
  
  //MARK: - Private
  
  /**
   Convert a CSV row to its OWL subclassOf representation
   
   - parameter row: CSV row map
   */
  private class func parseRow(row: [String: String]) -> String? {
    guard
      let annotation = row["Annotation"],
      let cateogry = row["Category"] else { return "" }
    
    if cateogry == "-" {
      return nil
    }
    
    let preparedAnnotation = (OWLNamer.prepareName(annotation) + "Annotation")
    .stringByReplacingOccurrencesOfString(" ", withString: "")
    
    let preparedCategory = getFinalCategory(cateogry)
    .stringByReplacingOccurrencesOfString(" ", withString: "")
    
    return
      [
        "    <SubClassOf>",
        "        <Class IRI=\"#\(preparedAnnotation)\"/>",
        "        <Class IRI=\"#\(preparedCategory)\"/>",
        "    </SubClassOf>"
        ].joinWithSeparator("\n")
  }
  
  private class func getFinalCategory(category: String) -> String {
    
    if category.containsString(";") {
      let lastCategory = category.componentsSeparatedByString("; ").last
      return lastCategory!
    }
    
    return category;
  }
  
}
