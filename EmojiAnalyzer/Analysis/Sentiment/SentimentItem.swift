//
//  SentimentItem.swift
//  EmojiOntology
//
//  Created by Omar Abdelhafith on 20/04/2016.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//

import Foundation

/**
 Sentiment item containing all info about an emoji sentiment.
 
 This class holds all the infromation stored in Sentiment.csv file.
 */
public final class SentimentItem {
  
  /**
   Unicode character value of emoji
   */
  public let unicodeChar: String
  
  /**
   Unicode character glyph of emoji
   */
  public let emoji: String
  
  /**
   Weight for the emoji usage.
   The weight is calculated by dividing the occurance of this emoji over the total 
   accumulative occurance of all emojis
   */
  public var weight: Double = 0.0
  
  /**
   Occurance of emoji usage
   */
  public let occurances: Double
  
  /**
   Negative occurances count for emoji
   */
  public let negativeOccurance: Double
  
  /**
   Neutral occurances count for emoji
   */
  public let neutralOccurance: Double
  
  /**
   Positive occurances count for emoji
   */
  public let positiveOccurance: Double
  
  /**
   Valance (sentiment value) for emoji.
   This value is calculated by substracting positive occurances from negative occurances
   */
  public var valence: Double {
    let positiveValance = self.positiveOccurance / self.occurances
    let negativeValance = self.negativeOccurance / self.occurances
    return positiveValance - negativeValance
  }
  
  /**
   Accumulative occurance of all emojis.
   This value is set after calculating all occurance counts.
   */
  var accumulativeOccurance: Double {
    didSet {
      weight = occurances / accumulativeOccurance
    }
  }
  
  init(
    unicodeChar: String,
    emoji: String,
    weight: Double,
    occurances: Double,
    negativeOccurance: Double,
    neutralOccurance: Double,
    positiveOccurance: Double) {
    
    self.unicodeChar = unicodeChar
    self.emoji = emoji
    self.weight = weight
    self.occurances = occurances
    self.negativeOccurance = negativeOccurance
    self.neutralOccurance = neutralOccurance
    self.positiveOccurance = positiveOccurance
    self.accumulativeOccurance = 1
  }
  
  /**
   Initialize a `SentimentItem` from a CSV row line.
   The line is broken up to pars and filled into the Sentiment model
   
   - parameter sentimentLine: CSV sentiment line
   */
  convenience init?(sentimentLine: String) {
    let cleanedLine = sentimentLine.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    
    let parts = cleanedLine.componentsSeparatedByString(",")
    if parts.count != 7 { return nil }
    
    let emoji = parts[0]
    let unicodeChar = parts[1]
    
    guard let
      occurances = Double(parts[2]),
      negativeOccurance = Double(parts[4]),
      neutralOccurance = Double(parts[5]),
      positiveOccurance = Double(parts[6]) else {
        return nil
    }
    
    self.init(
      unicodeChar: unicodeChar,
      emoji: emoji,
      weight: 0.0,
      occurances: occurances,
      negativeOccurance: negativeOccurance,
      neutralOccurance: neutralOccurance,
      positiveOccurance: positiveOccurance)
  }
}
