//
//  ViewController.swift
//  EmojiOntology
//
//  Created by Omar Abdelhafith on 25/02/2016.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//

import Cocoa
import EmojiAnalyzer

struct GenerationStyle {
  let title: String
  let subtitle: String
  let defaultFileName: String
  let callback: (String) -> ()
}

class ViewController: NSViewController {
  
  @IBOutlet var headerLabel: NSTextField!
  @IBOutlet var bodyLabel: NSTextField!
  @IBOutlet var progressView: NSProgressIndicator!
  @IBOutlet var generateButton: NSButton!
  @IBOutlet var segmentedControl: NSSegmentedControl!
  
  lazy var annotationsAndEmojis = EmojiReader.read(file: "Emoji Unicodes")
  
  var webViewLoader = WebViewLoader()
  
  var analysisGenerationStyle: GenerationStyle {
    return GenerationStyle(
      title: "Generate emoji color analysis",
      subtitle: "Convert each emojii to an image (png)\nUse the emoji image to calculate the most predominant color.",
      defaultFileName: "EmojiColors.plist",
      callback:self.analyseGeneratePressed)
  }
  
  var csvGenerationStyle: GenerationStyle {
    return GenerationStyle(
      title: "Generate emoji info CSV",
      subtitle: "Generate a CSV with all the metadata of an emoji\nThis csv contains: \n- the original unicode info\n- color informaion\n- sentiment analysis \n- and usage statistics of each emoji.",
      defaultFileName: "EmojiInformation.csv",
      callback: self.csvGeneratePressed)
  }
  
  var owlGenerationStyle: GenerationStyle {
    return GenerationStyle(
      title: "Generate OWL emoji file",
      subtitle: "Generate the Main OWL file that contains the ontology of emojis",
      defaultFileName: "EmojiOntology.owl",
      callback: self.owlGeneratePressed)
  }
  
  var usesGenerationStyle: GenerationStyle {
    return GenerationStyle(
      title: "Generate emoji usage analysis file",
      subtitle: "Generate a plist (key/value) that contains the usage number for each emoji.\nThe usage infromation is scraped from http://emojitracker.com/",
      defaultFileName: "EmojiUsage.plist",
      callback: self.usesGeneratePressed)
  }
  
  var currentGenerationStyle: GenerationStyle! {
    didSet {
      self.headerLabel.stringValue = currentGenerationStyle.title
      self.bodyLabel.stringValue = currentGenerationStyle.subtitle
    }
  }
  
  var emojis: [Emoji] {
    return self.annotationsAndEmojis.1
  }
  
  var annotations: [Annotation] {
    return self.annotationsAndEmojis.0
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    progressView.hidden = true
    progressView.minValue = 0
    progressView.maxValue = Double(emojis.count)
    
    currentGenerationStyle = owlGenerationStyle
  }
  
  
  @IBAction func textFieldEnterPressed(textView: NSTextField) {
    if textView.stringValue.isEmpty {
      return
    }
    
    analyseButtonPressed(textView)
  }
  
  @IBAction func analyseButtonPressed(sender: NSView) {
    let panel = NSSavePanel()
    panel.nameFieldLabel = "Save As:"
    panel.nameFieldStringValue = currentGenerationStyle.defaultFileName
    
    panel.beginSheetModalForWindow(self.view.window!) { code in

      if code == NSFileHandlingPanelOKButton {
        self.currentGenerationStyle.callback(panel.URL!.path!)
      }
    }
  }
  
  @IBAction func segmentControlChanged(sender: NSSegmentedControl) {
    switch sender.selectedSegment {
    case 0:
      currentGenerationStyle = analysisGenerationStyle
      break
    case 1:
      currentGenerationStyle = usesGenerationStyle
      break
    case 2:
      currentGenerationStyle = csvGenerationStyle
      break
    case 3:
      currentGenerationStyle = owlGenerationStyle
      break
      
    default:
      break
    }
  }
  
  func csvGeneratePressed(path: String) {
    let csv = CSVGenerator.generateCSV(properties: Emoji.propertyDescriptors, annotations: annotations, emojis: emojis)
    
    do {
      try csv.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
      self.showAlert("Saved successfully to \(path)", style: .InformationalAlertStyle)
    } catch {
      self.showAlert("Failed to save to \(path)", style: .CriticalAlertStyle)
    }
  }
  
  func owlGeneratePressed(path: String) {
    let owl = OWLGenerator.generateOWL(properties: Emoji.propertyDescriptors, annotations: annotations, emojis: emojis)
    do {
      try owl.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
      self.showAlert("Saved successfully to \(path)", style: .InformationalAlertStyle)
    } catch {
      self.showAlert("Failed to save to \(path)", style: .CriticalAlertStyle)
    }
  }
  
  func usesGeneratePressed(path: String) {
    self.setInterfaceEnabled(false)
    
    WebViewLoader.instance.loadUrl(
      NSURL(string: "http://www.emojitracker.com/")!,
      emojis: emojis) { result in
        
        self.setInterfaceEnabled(true)
        
        if result.toDictionary().writeToFile(path, atomically: false) {
          self.showAlert("Saved successfully to \(path)", style: .InformationalAlertStyle)
        } else {
          self.showAlert("Failed to save to \(path)", style: .CriticalAlertStyle)
        }
    }
  }
  
  func analyseGeneratePressed(path: String) {
    
    self.setInterfaceEnabled(false)
    
    let analyser = EmojiColorAnalyser(
      progressCallback: { current, total in
        
        self.progressView.maxValue = Double(total)
        self.progressView.doubleValue = Double(current)
      },
      finishedCallback: { result in
        
        self.setInterfaceEnabled(true)
        
        if EmojiColorAnalyser.toDictionary(result).writeToFile(path, atomically: false) {
          self.showAlert("Saved successfully to \(path)", style: .InformationalAlertStyle)
        } else {
          self.showAlert("Failed to save to \(path)", style: .CriticalAlertStyle)
        }
    })
    
    analyser.analyzeEmojis(emojis)
  }
  
  func setInterfaceEnabled(enabled: Bool) {
    self.generateButton.enabled = enabled
    self.segmentedControl.enabled = enabled
    self.progressView.hidden = enabled
  }
  
  func showAlert(message: String, style: NSAlertStyle) {
    let alert = NSAlert()
    alert.messageText = message
    alert.alertStyle = style
    alert.addButtonWithTitle("Ok")
    alert.beginSheetModalForWindow(self.view.window!, completionHandler: nil)
  }
  
}

