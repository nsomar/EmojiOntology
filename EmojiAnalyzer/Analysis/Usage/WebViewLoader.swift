//
//  WebViewLoader.swift
//  DublinBusMenu
//
//  Created by Omar Abdelhafith on 02/02/2016.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//

import WebKit

/**
 This class starts a web kit view in the background and uses mac javascript bridge to read 
 values from the loaded webpage dom.
 */
public class WebViewLoader: NSObject, WKNavigationDelegate {
  
  /**
   Call back used to inform the usage information
   */
  public typealias FinishedCallback = (EmojiUsageAnalyser) -> ()
  var finishCallback: FinishedCallback?
  
  private let webView: WKWebView!
  private var emojis: [Emoji]!
  
  /**
   Singleton to quickly get an instance of `WebViewLoader`
   */
  public static let instance = WebViewLoader()
  
  public override init() {
    self.webView = WKWebView()
    
    super.init()
    
    self.webView.navigationDelegate = self
  }
  
  /**
   Load a url into the internal WKWebView and fill the usage information for the passed emojis list.
   
   - parameter url: url to fetch emoji info from
   
   - parameter emojis: list of emojis to get usage info for
   
   - parameter finishCallback: callback to inform fetching ended
   */
  public func loadUrl(url: NSURL, emojis: [Emoji], finishCallback: FinishedCallback) {
    self.emojis = emojis
    self.finishCallback = finishCallback
    self.webView.loadRequest(NSURLRequest(URL: url))
  }
  
  public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {

    after(1) {
      webView.evaluateJavaScript("document.body.innerText") { result, error in
        self.finishCallback?(EmojiUsageAnalyser(emojiText: result as! String))
      }
    }
  }
  
}
