//
//  OWLGenerator.swift
//  EmojiOntology
//
//  Created by Omar Abdelhafith on 26/02/2016.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//

import Foundation

/**
 Generates an OWL file with the Emoji info.
 
 This class convets a list of emoji proparties, annotations and emojis to an OWL/XML ontology.
 It uses an Emoji Ontology template file and fills it with the parametrs passed to it.
 */
public class OWLGenerator {
  
  /**
   Generate an OWL string for the given emojis, annotations and properties
   
   - parameter properties: Emoji properties to export to CSV
   
   - parameter annotations: Annotations to export to CSV
   
   - paramter emojis: Emojis list to export to CSV
   */
  public class func generateOWL(properties properties: [OWLProperty], annotations: [Annotation], emojis: [Emoji]) -> String {
    var string = try! String(contentsOfFile: NSBundle(forClass: self).pathForResource("Emoji", ofType: "owl")!)
    
    string = string
      .stringByReplacingOccurrencesOfString("%%%AnnotationCategories%%%",
                                            withString: additionalCategories())
    
    string = string
      .stringByReplacingOccurrencesOfString("%%%Colors%%%",
                                            withString: self.generateColors())
    
    string = string
      .stringByReplacingOccurrencesOfString("%%%DataProps%%%",
                                            withString: self.generatePropertiesDescriptor(properties))
    
    string = string
      .stringByReplacingOccurrencesOfString("%%%Annotations%%%",
                                            withString: self.generateAnnotations(annotations))
    
    string = string
      .stringByReplacingOccurrencesOfString("%%%Emojis%%%",
                                            withString: self.generateEmoji(emojis))
    
    string = string
      .stringByReplacingOccurrencesOfString("%%%AnnotationCategoriesSubclasses%%%",
                                            withString: self.generateAdditionalCategorySubclasses())
    
    return string
  }
  
  /**
   Generate OWL representation for each annotation
   */
  class func generateAnnotations(annotations: [Annotation]) -> String {
    return
      annotations.map { item in
        item.toOwlXML()
        }.joinWithSeparator("\n")
  }
  
  /**
   Generate OWL representation for the emoji properties
   */
  class func generatePropertiesDescriptor(properties: [OWLProperty]) -> String {
    return
      properties.map { item in
        item.toOwnDescriptorXML()
        }.joinWithSeparator("\n")
  }
  
  /**
   Generate OWL for a list of owl convertible items
   */
  class func generateOWLForItems(items: [OWLConvertible]) -> String {
    return
      items.map { item in
        item.toOwlXML()
        }.joinWithSeparator("\n")
  }
  
  /**
   Generate OWL for a list of emojis
   */
  class func generateEmoji(emojis: [Emoji]) -> String {
    return
      emojis.map { item in
        item.toOwlXML()
        }.joinWithSeparator("\n")
  }
  
  /**
   Generate OWL for the additional annotation categories
   */
  class func generateAdditionalCategorySubclasses() -> String {
    return AdditionalCategories.read(file: "Annotation Categories")
  }
  
  
  //MARK: - Privates
  
  /**
   Generate OWL entity item for the known colors
   */
  private class func generateColors() -> String {
    let discreptor = [
      "    <Declaration>",
      "        <Class IRI=\"#Colors\"/>",
      "    </Declaration>",
      "    <Declaration>",
      "        <ObjectProperty IRI=\"#hasColor\"/>",
      "    </Declaration>"
      ].joinWithSeparator("\n")
    
    let colors = EmojiDrawer.colors().map { color, _ in
      [
        "    <SubClassOf>",
        "        <Class IRI=\"#\(color)Color\"/>",
        "        <Class IRI=\"#Colors\"/>",
        "    </SubClassOf>"
        ].joinWithSeparator("\n")
      }.joinWithSeparator("\n")
    
    return [discreptor, colors].joinWithSeparator("\n")
  }
  
  /**
   Read the annotation categories xml fiel
   */
  private class func additionalCategories() -> String {
    return try! String(contentsOfFile: NSBundle(forClass: self).pathForResource("AnnotationCategories", ofType: "xml")!)
  }
  
}
