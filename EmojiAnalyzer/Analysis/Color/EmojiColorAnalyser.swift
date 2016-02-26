//
//  EmojiColorAnalyser.swift
//  EmojiOntology
//
//  Created by Omar Abdelhafith on 27/02/2016.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//

import Cocoa
import Colours


private var _cachedColors: [String: [String: String]]?

/**
 Class responsible to analyze the colors of an emoji
 
 To calculate the color of an emoji we do the following:
 
 - Because emoji is a character, we draw the character on a context
 - We store the context to an image of 40 x 40
 - We save the image to disk
 - We invoke`imagemagick` utility with the file saved.
 - To get the color of an image we convert it to a 1x1 pixel image and we read the color of this pixel, this is how image magick  processes the color of an image.
 - After getting the color pixel info, we get the name of this color by comparing the pixel info to a stored colors (Red, Blue, Yellow, Green, Purple, Orange, Black, Brown, White, Gray, Cyan).
 - Because getting the color of an emoji is computationally expensive, after creating the CSV of all colours once. I stored this Plist in the app, When creating the OWL file, I read the color info for the emojis from this list
*/
public class EmojiColorAnalyser {
  
  /**
   Emoji analysis result type
   */
  public typealias EmojiColorAnalysisResult = (Emoji, String)
  
  /**
   Callback called with the progress of emoji analysis
   */
  public typealias ProgressCallback = (Int, Int) -> ()
  
  /**
   Callback called with the progress of emoji analysis
   */
  let progressCallback: ProgressCallback
  
  /**
   Callback called when analysis ends
   */
  public typealias FinishedCallback = ([EmojiColorAnalysisResult]) -> ()
  /**
   Callback called when analysis ends
   */
  let finishedCallback: FinishedCallback
  
  /**
   Initialize an `EmojiColorAnalyser` object
   
   - parameter progressCallback: progress callback to call
   
   - parameter finishedCallback: callback to call when analysis ends
   */
  public init(progressCallback: ProgressCallback, finishedCallback: FinishedCallback) {
    self.progressCallback = progressCallback
    self.finishedCallback = finishedCallback
  }
  
  /**
   Analyze a list of emojis to calculate their colors
   When this method is done with the calculation it calls the `finishedCallback` callback
   
   - parameter emojis: list of emoji to analyze
   */
  public func analyzeEmojis(emojis: [Emoji]) {
    
    var progress = 0
    var result = [EmojiColorAnalysisResult]()
    
    onBackground {
      
      emojis.forEach { emoji in
        
        progress = progress + 1
        onMain {
          // Inform progress mad
          self.progressCallback(progress, emojis.count)
        }
        
        // Append a new analysis result
        let namedColor = EmojiColorAnalyser.namedColor(emoji)
        result.append(emoji, namedColor)
      }
      
      onMain {
        // Inform analysis ended
        self.finishedCallback(result)
      }
    }
  }
  
  /**
   Get a named color for an emoji
   Named colored are strings (Blue, Red, Green etc...)
   
   - parameter emoji: emoji to get color for
   */
  class func namedColor(emoji: Emoji) -> String {
    let tempfile = self.tempFile("\(emoji.name).png")
    
    let colorName =
    EmojiDrawer.drawEmoji(emoji.emojiGlyph)
      |> EmojiDrawer.saveToFile(tempfile)
      |> EmojiDrawer.dominantColor
      |> { $0[1..<7] }
      |> { NSColor(fromHexString: $0) }
      |> EmojiColorAnalyser.namedColor
    
    self.deleteFile(tempfile)
    
    return colorName!
  }
  
  /**
   Convert the emoji analysis result to an NSDictionary containing the emoji as key and the color as value
   
   - parameter result: emoji color analysis (Emoji, Color name)
   */
  public class func toDictionary(result: [EmojiColorAnalysisResult]) -> NSDictionary {
    var dict = [String: [String: String]]()
    
    result.forEach { emoji, color in
      dict[emoji.name] = ["glyph": emoji.emojiGlyph, "color": color]
    }
    
    return (dict as NSDictionary)
  }
  
  /**
   Get the name of an NSColor
   
   - parameter dominant: color
   */
  static func namedColor(dominant: NSColor) -> String {
    return EmojiDrawer.colors().map { name, color in
      
      return (name, dominant.distanceFromColor(color, type: .CIE2000))
      }.sort { v1, v2 in
        return v1.1 < v2.1
      }.first!.0
  }
  
  /**
   Get a cached name for an emoji. 
   After calculating the color for an emoji. The color is cached for future reuse.
   
   - parameter emoji: emoji to get color for
   */
  static func cachedColorForEmoji(emoji: Emoji) -> String {
    return self.cachedColors[emoji.name]!["color"]!
  }
  
  //MARK: - Private
  
  private class var cachedColors: [String: [String: String]] {
    if let cachedColors = _cachedColors {
      return cachedColors
    }
    
    let path = NSBundle(forClass: self).pathForResource("EmojiColor", ofType: "plist")
    _cachedColors = (NSDictionary(contentsOfFile: path!) as! [String: [String: String]])
    return _cachedColors!
  }
  
  //MARK: - Temp file
  
  private class func tempFile(name: String) -> String {
    return NSTemporaryDirectory().stringByAppendingString("\(name)")
  }
  
  private class func deleteFile(file: String) {
    try! NSFileManager.defaultManager().removeItemAtPath(file)
  }
  
}