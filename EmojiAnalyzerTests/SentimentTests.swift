//
//  SentimentTests.swift
//  ParseEmoji
//
//  Created by Omar Abdelhafith on 02/03/2016.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Sentiment

class SentimentSpec: QuickSpec {
  
  override func spec() {
    
    describe("SentimentRow") {
      
      it("can be initalized with a csv row") {
        let row = SentimentItem(sentimentLine: "1F60D,0x1f60d,6359,0.765292366,329,1390,4640")!
        expect(row.emoji) == "1F60D"
        expect(row.unicodeChar) == "0x1f60d"
        expect(row.occurances) == 6359 ± 1
        expect(row.negativeOccurance) == 329 ± 1
        expect(row.neutralOccurance) == 1390 ± 1
        expect(row.positiveOccurance) == 4640 ± 1
      }
      
      it("ignores \r") {
        expect(SentimentItem(sentimentLine: "1F60D,0x1f60d,6359,0.765292366,329,1390,4640\r")).notTo(beNil())
      }
      
      it("return nil if malformed") {
        expect(SentimentItem(sentimentLine: "1F60D,0x1f60d,6359,0.765292366,329,1390,4640,1")).to(beNil())
        expect(SentimentItem(sentimentLine: "1F60D,0x1f60d,6359,0.765292366,329,1390")).to(beNil())
        expect(SentimentItem(sentimentLine: "1F60D,0x1f60d,6359,0.765292366,329,1390,a")).to(beNil())
      }
      
      it("calculate valance") {
        let row = SentimentItem(
          unicodeChar: "", emoji: "", weight: 0,
          occurances: 6359,
          negativeOccurance: 329,
          neutralOccurance: 1390,
          positiveOccurance: 4640)
        
        expect(row.valence) == 0.6779 ± 0.001
      }
      
      it("calculate the weight, when acc is given") {
        let row = SentimentItem(
          unicodeChar: "", emoji: "", weight: 0,
          occurances: 6359,
          negativeOccurance: 329,
          neutralOccurance: 1390,
          positiveOccurance: 4640)
        
        row.accumulativeOccurance = 146220
        expect(row.weight) == 0.04 ± 0.01
      }
      
    }
    
    
    describe("SentimentAnalyzer") {

      it("reads the csv and stores the array of sentiments") {
        let sentiments = SentimentAnalyzer()
        expect(sentiments.items.count) == 969
        
        let sentiment = sentiments["1F602"]!
        expect(sentiment.emoji) == "😂"
        expect(sentiment.unicodeChar) == "0x1f602"
        expect(sentiment.weight) == 0.0931 ± 0.01
      }
      
      it("reads the csv") {
        let (sentiments, acc) = SentimentAnalyzer.readCSV()!
        expect(sentiments.count) == 969
        expect(acc) == 156941 ± 0.01
      }
      
      it("returns a sentiment for an emoji") {
        let sentiments = Sentiment["1F496"]!
        expect(sentiments.emoji) == "💖"
        expect(sentiments.valence) == 0.713380839271576 ± 0.01
        expect(sentiments.weight) == 0.00804761024843731 ± 0.001
        
        let sentiments1 = Sentiment["0x1F496"]!
        expect(sentiments1.emoji) == "💖"
        
        let sentiments2 = Sentiment["u+1F496"]!
        expect(sentiments2.emoji) == "💖"
      }
      
      it("returns nil if not an emoji") {
        let sentiments = Sentiment["1"]
        expect(sentiments).to(beNil())
      }
      
      it("adjusts items weights") {
        let sentiments = [
          "1": SentimentItem(
            unicodeChar: "", emoji: "", weight: 0,
            occurances: 1000,
            negativeOccurance: 1,
            neutralOccurance: 1,
            positiveOccurance: 1),
          
          "2": SentimentItem(
            unicodeChar: "", emoji: "", weight: 0,
            occurances: 2000,
            negativeOccurance: 329,
            neutralOccurance: 1390,
            positiveOccurance: 4640)
        ]
        
        let acc = 3000.0
        let updated = SentimentAnalyzer.updateSentiments(sentiments, withAccumulativeOccurances: acc)
        
        expect(updated["1"]!.weight) == 0.33 ± 0.1
        expect(updated["2"]!.weight) == 0.67 ± 0.1
      }
      
    }
    
  }
}
