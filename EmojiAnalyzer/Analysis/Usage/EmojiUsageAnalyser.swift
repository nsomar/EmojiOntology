//
//  EmojiUsageAnalyser.swift
//  EmojiOntology
//
//  Created by Omar Abdelhafith on 28/02/2016.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//

import Foundation

private var cachedEmojiUses: EmojiUsageAnalyser!


/**
 Class responsible for analysing the emoji usage
 */
public struct EmojiUsageAnalyser {
  
  /**
   Map with emoji as key and usage information as value
   */
  private var parsedEmojiUses: [String: Int]
  
  /**
   Create an `EmojiUsageAnalyser` from a string containing all emojis and their usage.
   This list is taken from `emojitracker.com`
   
   - parameter emojiText: emoji usage string
   */
  init(emojiText: String) {
    self.parsedEmojiUses = EmojiUsageAnalyser.parseEmojiText(emojiText)
  }
  
  /**
   Create an `EmojiUsageAnalyser` with a map of emoji and their usages
   
   - parameter emojiText: map containing emoji as key and usage as value
   */
  init(parsedEmojiUses: [String: Int]) {
    self.parsedEmojiUses = parsedEmojiUses
  }
  
  /**
   Read `EmojiUsageAnalyser` from plist stored in app (cached plist)
   */
  static func fromCache() ->  EmojiUsageAnalyser {
    if cachedEmojiUses == nil {
      
      let path = NSBundle(forClass: SentimentAnalyzer.self).pathForResource("EmojiUses", ofType: "plist")
      let emojiUses = (NSDictionary(contentsOfFile: path!) as! [String: Int])
      cachedEmojiUses = EmojiUsageAnalyser(parsedEmojiUses: emojiUses)
    }

    return cachedEmojiUses
  }
  
  /**
   Parse emoji usage string and convert it to a emoji to usage map
   */
  static func parseEmojiText(emojiText: String) -> [String: Int] {
    let array = emojiText.componentsSeparatedByString("\n")[1].componentsSeparatedByString(" ")
    
    var res = [String: Int]()
    
    for index in 0.stride(to: array.count, by: 2) {
      let key = array[index]
      let value = array[index + 1]
      res[key] = Int(value)
    }
    
    return res
  }
  
  /**
   Return the usage number for a particular emoji
   
   - parameter key: emoji to get usage for
   */
  subscript (key: String) -> Int {
    return parsedEmojiUses[key] ?? 0
  }
  
  /**
   Calculate the percentage usage for a given emoji.
   The percentage usage = (total number of emoji usage) / (current emoji usage)
   
   - parameter key: emoji to get usage for
   */
  func percentageUsage(key: String) -> Double {
    let total = parsedEmojiUses.values.reduce(0) { acc, item in
      return item + acc
    }
    
    return (Double(self[key]) / Double(total)) * 100.0
  }
  
  /**
   Get a dictionary representation of the parsed emoji.
   
   Dictionary mapping the emoji string as key and usage as value.
   */
  public func toDictionary() -> NSDictionary {
    return (parsedEmojiUses as NSDictionary)
  }

}