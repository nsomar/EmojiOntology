//
//  SentimentAnalyzer.swift
//  EmojiOntology
//
//  Created by Omar Abdelhafith on 02/03/2016.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//

import Foundation


/**
 Singleton to access the `SentimentAnalyzer`
 */
public let Sentiment = SentimentAnalyzer()

/**
 Class responsible to get the sentiment information of an emoji.
 
 The sentiment information is read from bundled Sentiment.csv.
 This sentiment file contains the positive, negative and neutral occurance for each emoji.
 
 The sentiment information is calculalted by comparing the positive occurance number to the negative occurance number.
 */
public class SentimentAnalyzer {
  
  /**
   Map containing the emoji as key and sentiment as value
   */
  let items: [String: SentimentItem]!
  
  init() {
    self.items =
      (SentimentAnalyzer.readCSV()
        |> SentimentAnalyzer.updateSentiments)!
  }
  
  /**
   Return a sentiment item for an emoji unicode
   
   - parameter unicode: unicode to get sentiment for
   */
  public subscript(unicode: String) -> SentimentItem? {
    return items[SentimentAnalyzer.cleanUnicode(unicode)]
  }
  
  /**
   Read emoji sentiment CSV and parse it to sentiment info (sentiment, accumulative occurances)
   */
  class func readCSV() -> (sentiment: [String: SentimentItem], accumulative: Double)? {
    guard let filePath = NSBundle(forClass: self).pathForResource("Sentiment", ofType: "csv") else { return nil }
    guard let stream = StreamReader(path: filePath) else { return nil }
    
    var items = [String: SentimentItem]()
    
    stream.nextLine()
    var accumulativeOccurances = 0.0
    
    // Get line
    while let line = stream.nextLine() {
      // Create a sentiment for that line
      guard let sentiment = SentimentItem(sentimentLine: line) else { continue }
      
      // Calculate the accumulative occurance
      accumulativeOccurances += sentiment.occurances
      
      // Save the sentiment for the current unicode
      items[cleanUnicode(sentiment.unicodeChar)] = sentiment
    }
    
    return (items, accumulativeOccurances)
  }
  
  /**
   Update the storead sentiments with the final accumulative occurance count.
   The accumulative count can only be calculated when all sentiments are calculated.
   
   - parameter sentiments: list of sentiments to update
   
   - parameter accumulative: the final accumulative occurance count
   */
  class func updateSentiments(sentiments: [String: SentimentItem],
                              withAccumulativeOccurances accumulative: Double) -> [String: SentimentItem] {
    
    sentiments.forEach { (emoji, sentiment) in
      sentiment.accumulativeOccurance = accumulative
    }
    
    return sentiments
  }
  
  //MARK: - Private
  
  private class func cleanUnicode(input: String) -> String {
    var cleaned = input.uppercaseString.stringByReplacingOccurrencesOfString("0X", withString: "")
    cleaned = cleaned.stringByReplacingOccurrencesOfString("U+", withString: "")
    return cleaned
  }
  
}
