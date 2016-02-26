//
//  EmojiDrawer.swift
//  EmojiOntology
//
//  Created by Omar Abdelhafith on 27/02/2016.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//

import Cocoa
import Swiftline


/**
 Class responsible to draw an emoji to an image.
 
 This class draws an emoji to an NSImage. The NSImage is then saved to disk and used to perform color detection using ImageMagick.
 
 The RGB calculated is then converted to a known color (out of 11 possibilities).
 */
class EmojiDrawer {

  /**
   Draw an emoji to an NSImage
   
   - parameter emoji: emoji glyph to draw
   */
  class func drawEmoji(emoji: String) -> NSImage {
    let img = NSImage(size: NSSize(width: 40, height: 40))
    
    img.lockFocus()
    (emoji as NSString).drawAtPoint(NSPoint(x: 0, y: 0),
                                    withAttributes: [NSFontAttributeName: NSFont.systemFontOfSize(22)])
    img.unlockFocus()
    
    return img
  }
  
  /**
   Save an NSImage to a file
   
   - parameter file: output file
   
   - parameter iamge: image to save
   */
  class func saveToFile(file: String)(image: NSImage) -> String {
    let presentation = NSBitmapImageRep(data: image.TIFFRepresentation!)!
    
    let data = presentation.representationUsingType(NSBitmapImageFileType.NSPNGFileType,
                                                    properties: [NSImageCompressionFactor: 1])!
    data.writeToFile(file, atomically: false)
    
    return file
  }
  
  /**
   Get the dominant color for a file. This file should be an image that contains the emoji
   
   - parameter file: the image file location
   */
  class func dominantColor(file: String) -> String {
    let imageMagick = NSBundle(forClass: self).pathForResource("convert", ofType: "")!
    NSLog("The path is %@", imageMagick)
    
    let x = run(imageMagick, args: [file, "+dither", "-colors", "1", "-format", "\"%c\"", "histogram:info:"])
    NSLog("value is %@", x.stdout)
    NSLog("error is is %@", x.stderr)
    let color = x.stdout.componentsSeparatedByString(" ").filter { string in
      return string.hasPrefix("#")
    }.first!
    
    return color
  }
  
  static func xxx(priority : Int32, _ message : String, _ args : CVarArgType...) {
    withVaList(args) { vsyslog(priority, message, $0) }
  }
  
  /**
   List of named colors. These colored will be matched agains an emoji.
   */
  class func colors() -> ([String: NSColor]) {
    return [
      "Red": NSColor(fromHexString: "ff0000"),
      "Blue": NSColor(fromHexString: "0000ff"),
      "Yellow": NSColor(fromHexString: "ffff00"),
      "Green": NSColor(fromHexString: "008000"),
      "Purple": NSColor(fromHexString: "800080"),
      "Orange": NSColor(fromHexString: "ffa500"),
      "Black": NSColor(fromHexString: "000000"),
      "Brown": NSColor(fromHexString: "a52a2a"),
      "White": NSColor(fromHexString: "ffffff"),
      "Gray": NSColor(fromHexString: "808080"),
      "Cyan": NSColor(fromHexString: "00ffff"),
    ]
  }
  
}