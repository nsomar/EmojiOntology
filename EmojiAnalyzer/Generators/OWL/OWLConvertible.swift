//
//  OWLConvertible.swift
//  EmojiOntology
//
//  Created by Omar Abdelhafith on 26/02/2016.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//


/**
 Protocol defining the requirements for an object to be convertible to OWL
 */
protocol OWLConvertible {
  func toOwlXML() -> String
}


extension Annotation: OWLConvertible {
  
  /**
   Convert an annotation to an OWL XML entity
   */
  func toOwlXML() -> String {
    return [
      "    <Declaration>",
      "        <Class IRI=\"#\(name)\"/>",
      "    </Declaration>",
      "    <SubClassOf>",
      "        <Class IRI=\"#\(name)\"/>",
      "        <Class IRI=\"#Annotations\"/>",
      "    </SubClassOf>"
      ].joinWithSeparator("\n")
  }
  
}


extension Emoji: OWLConvertible {
  
  /**
   Convert an emoji to an OWL XML entity
   */
  func toOwlXML() -> String {
    return [
      "    <Declaration>",
      "        <Class IRI=\"#\(name)\"/>",
      "    </Declaration>",
      "    <SubClassOf>",
      "        <Class IRI=\"#\(name)\"/>",
      "        <Class IRI=\"#Emoji\"/>",
      "    </SubClassOf>",
      "    <SubClassOf>",
      "        <Class IRI=\"#\(name)\"/>",
      "        <ObjectIntersectionOf>",
      annotationsOWL(),
      "        </ObjectIntersectionOf>",
      "    </SubClassOf>",
      propertiesOWL(),
      colorOWL(),
      ].joinWithSeparator("\n")
  }
  
  // MARK: - Private
  
  private func annotationsOWL() -> String {
    return
      annotations.map { annotation in
        return "            <Class IRI=\"#\(annotation.name)\"/>"
        }.joinWithSeparator("\n")
  }
  
  private func propertiesOWL() -> String {
    return properties.map { property in
      property.toOwlXML()
      }.joinWithSeparator("\n")
  }
  
  private func colorOWL() -> String {
    return [
      "    <SubClassOf>",
      "        <Class IRI=\"#\(name)\"/>",
      "        <ObjectSomeValuesFrom>",
      "            <ObjectProperty IRI=\"#hasColor\"/>",
      "            <Class IRI=\"#\(self.color)Color\"/>",
      "        </ObjectSomeValuesFrom>",
      "    </SubClassOf>"
    ].joinWithSeparator("\n")
  }
  
}

/**
 OWL Data Property types
 */
public enum OWLPropertyType: String {
  /**
   OWL Integer data property type
   */
  case IntValue = "http://www.w3.org/2001/XMLSchema#integer"
  
  /**
   OWL String data property type
   */
  case StringValue = "http://www.w3.org/1999/02/22-rdf-syntax-ns#PlainLiteral"
  
  /**
   OWL Double data property type
   */
  case DoubleValue = "http://www.w3.org/2001/XMLSchema#double"
}

/**
 Struture that represent an emoji proparty.
 
 This proparty is then represented as an OWL data property tipe.
 */
public struct OWLProperty: OWLConvertible {
  /**
   OWL property name
   */
  let name: String
  
  /**
   OWL property value
   */
  let value: String
  
  /**
   The OWL class name
   */
  let className: String
  
  /**
   The OWL property type
   */
  let propertyType: OWLPropertyType
  
  /**
   Convert a property to an OWL XML descriptor
   */
  func toOwnDescriptorXML() -> String {
    return [
      "    <Declaration>",
      "        <DataProperty IRI=\"#\(self.name)\"/>",
      "    </Declaration>"
      ].joinWithSeparator("\n")
  }
  
  /**
   Convert a property to an OWL XML entity
   */
  func toOwlXML() -> String {
    return [
      "    <SubClassOf>",
      "        <Class IRI=\"#\(className)\"/>",
      "        <DataHasValue>",
      "            <DataProperty IRI=\"#\(name)\"/>",
      "            <Literal datatypeIRI=\"\(propertyType.rawValue)\">\(value)</Literal>",
      "        </DataHasValue>",
      "    </SubClassOf>"
      ].joinWithSeparator("\n")
  }
}