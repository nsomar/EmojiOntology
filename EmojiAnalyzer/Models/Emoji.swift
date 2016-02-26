//
//  Emoji.swift
//  EmojiOntology
//
//  Created by Omar Abdelhafith on 25/02/2016.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//

import Foundation

/**
 Emoji class representing an emoji.
 
 This object contains instance variables for each of the emoji properties.
 */
public class Emoji {
  
  /**
   Emoji unicode value
   */
  let unicode: String
  
  /**
   Emoji glyph
   */
  let emojiGlyph: String
  
  /**
   Emoji description
   */
  let description: String
  
  /**
   Year emoji was introduced
   */
  let year: String
  
  /**
   Emoji nature (text, emoji)
   */
  let nature: String
  
  /**
   List of emoji annotations
   */
  let annotations: [Annotation]
  
  /**
   Emoji sentiment value.
   This value is read from the sentiment framework.
   */
  var sentiment: Double {
    return Sentiment[unicode]?.valence ?? 0
  }
  
  /**
   Average sentiment value. 
   Sentiment Value * percentage usage
   */
  var averageSentiment: Double {
    let value = sentiment * percentageUsage
    return value < 0.0001 ? 0 : value
  }
  
  /**
   Emoji color name. 
   This name is read from the emoji color analyzer emoji-color map (disk cached copy).
   */
  var color: String {
    return EmojiColorAnalyser.cachedColorForEmoji(self)
  }

  /**
   Usage number for an emoji. 
   This number is read from the emoji usage analyzer (disk cached copy).
   */
  var usage: Int {
    return EmojiUsageAnalyser.fromCache()[emojiGlyph]
  }
  
  /**
   Emoji percentage usage.
   emoji usage / total emoji usages
   This number is read from the emoji usage analyzer (disk cached copy).
   */
  var percentageUsage: Double {
    return EmojiUsageAnalyser.fromCache().percentageUsage(emojiGlyph)
  }
  
  /**
   Emoji formal name, used when storing to CSV and OWL.
   */
  var name: String {
    return OWLNamer.prepareName(description) + "Emoji"
  }
  
  /**
   Emoji web unique id, this value is calculated from the unicode value.
   */
  var webID: String {
    return unicode.substringFromIndex(unicode.startIndex.advancedBy(2))
      .stringByReplacingOccurrencesOfString(" U+", withString: "-")
  }
  
  init(unicode: String, emojiGlyph: String, description: String, year: String, nature: String, annotations: [Annotation]) {
    self.unicode = unicode
    self.emojiGlyph = emojiGlyph
    self.description = description
    self.year = year
    self.nature = nature
    self.annotations = annotations
  }
  
  init(withDictionary dic: [String: String]) {
    unicode = dic["Unicode"]!
    emojiGlyph = dic["Emoji"]!
    description = dic["Description"]!
    year = dic["Year"]!
    nature = dic["Nature"]!
    annotations = Annotation.fromString(dic["Annotations"])
  }
  
  /**
   Create a list of emojis from a list of emoji comma seperated emoji rows.
   
   - parameter csvRows: list of CSV rows.
   */
  class func fromArray(csvRows: [[String: String]]) -> [Emoji] {
    return csvRows.map { row in
      return Emoji.init(withDictionary: row)
    }
  }
  
  /**
   List of OWLProperty an emoji has. This list is used when saving an emoji to OWL.
   */
  var properties: [OWLProperty] {
    return [
      OWLProperty(name: "hasUnicode",         value: unicode, className: name, propertyType: .StringValue),
      OWLProperty(name: "hasEmojiGlyph",      value: emojiGlyph, className: name, propertyType: .StringValue),
      OWLProperty(name: "hasDescription",     value: description, className: name, propertyType: .StringValue),
      OWLProperty(name: "hasYear",            value: year, className: name, propertyType: .IntValue),
      OWLProperty(name: "hasNature",          value: nature, className: name, propertyType: .StringValue),
      OWLProperty(name: "hasUsageNumber",     value: "\(usage)", className: name, propertyType: .DoubleValue),
      OWLProperty(name: "hasUsagePercentage", value: "\(percentageUsage)", className: name, propertyType: .DoubleValue),
      OWLProperty(name: "hasSentiment", value: "\(sentiment)", className: name, propertyType: .DoubleValue),
      OWLProperty(name: "hasAverageSentiment", value: "\(averageSentiment)", className: name, propertyType: .DoubleValue)
    ]
  }
  
  /**
   List of OWLProperty an emoji has.
   */
  public class var propertyDescriptors: [OWLProperty] {
    return [
      OWLProperty(name: "hasUnicode", value: "", className: "Emoji", propertyType: .StringValue),
      OWLProperty(name: "hasEmojiGlyph", value: "", className: "Emoji", propertyType: .StringValue),
      OWLProperty(name: "hasDescription", value: "", className: "Emoji", propertyType: .StringValue),
      OWLProperty(name: "hasYear", value: "", className: "Emoji", propertyType: .IntValue),
      OWLProperty(name: "hasNature", value: "", className: "Emoji", propertyType: .StringValue),
      OWLProperty(name: "hasUsageNumber", value: "", className: "Emoji", propertyType: .DoubleValue),
      OWLProperty(name: "hasUsagePercentage", value: "", className: "Emoji", propertyType: .DoubleValue),
      OWLProperty(name: "hasSentiment", value: "", className: "Emoji", propertyType: .DoubleValue),
      OWLProperty(name: "hasAverageSentiment", value: "", className: "Emoji", propertyType: .DoubleValue)
    ]
  }
}
