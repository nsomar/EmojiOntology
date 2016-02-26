//
//  OWLNamer.swift
//  EmojiOntology
//
//  Created by Omar Abdelhafith on 26/02/2016.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//

import Foundation

/**
 Class responsible to sanitize a string to be usable as an OWL entity name.
 
 It genereates correct names that can be used as OWL/XML entity names.
 */
class OWLNamer {
  
  /**
   Return the sanitized name for a given name.
   This name can then be used as an OWL entity name.
   
   - parameter name: name to sanitize
   */
  class func prepareName(name: String) -> String {
    return name.componentsSeparatedByString(" ").map { part in
      part.capitalizedString.stringByReplacingOccurrencesOfString(":", withString: "-")
      |> removeSpecialCharacters
      }.joinWithSeparator("")
  }
  
  //MARK: - Privates
  
  private class func removeSpecialCharacters(string: String) -> String {
    var retString = string
    
    charactersToRemove().forEach { char in
      retString = retString.stringByReplacingOccurrencesOfString(char, withString: "")
    }
    
    return retString
  }
  
  private class func charactersToRemove() -> [String] {
    return ["!", "#"]
  }
}