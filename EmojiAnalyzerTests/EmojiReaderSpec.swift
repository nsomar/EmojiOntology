import Quick
import Nimble
@testable import EmojiAnalyzer

class EmojiReaderSpec: QuickSpec {
  
  override func spec() {
    
    describe("Emoji Reader") {
      
      it("reads emoji and annotations") {
        let emojis = EmojiReader.read(file: "Emoji Unicodes")
        
        expect(emojis.0.count) == 1174
        expect(emojis.1.count) == 845
      }
      
      it("parses a ; seperated string of annotations") {
        let annotations = Annotation.fromString("eye; face; grin; person happy; smile")
        
        expect(annotations.count) == 5
        expect(annotations.map { $0.annotation }) == ["eye", "face", "grin", "person happy", "smile"]
      }
      
    }
    
    describe("OWL generation") {
      
      it("generates owl for annotations") {
        let annotations = [
          Annotation(withString: "Smile"),
          Annotation(withString: "Face"),
        ]
        
        let xml = OWLGenerator.generateAnnotations(annotations)
        expect(xml) == self.loadData("owl_annotations")
      }
      
      it("generates owl for emojis") {
        let emoji1 = Emoji.init(unicode: "X", emojiGlyph: "X", description: "grinning face",
          year: "2010", nature: "emoji",
          annotations: [Annotation(withString: "Face"), Annotation(withString: "Smile")])
        
        let emoji2 = Emoji.init(unicode: "X", emojiGlyph: "X", description: "grinning face with smiling eyes",
          year: "2010", nature: "emoji",
          annotations: [Annotation(withString: "Face"), Annotation(withString: "Sad")])
        
        
        try! OWLGenerator.generateEmoji([emoji1, emoji2]).writeToFile("/Users/oabdelhafith/Desktop/x", atomically: false, encoding: NSUTF8StringEncoding)
        expect(OWLGenerator.generateEmoji([emoji1, emoji2])) == self.loadData("owl_emojis")
        
      }
      
      it("generates owl for properties") {
        expect(OWLGenerator.generatePropertiesDescriptor(
          [OWLProperty(name: "prop1", value: "", className: "", propertyType: .StringValue),
            OWLProperty(name: "prop2", value: "", className: "", propertyType: .StringValue)])) == "    <Declaration>\n        <DataProperty IRI=\"#prop1\"/>\n    </Declaration>\n    <Declaration>\n        <DataProperty IRI=\"#prop2\"/>\n    </Declaration>"
      }
      
      it("generates owl for emojis and annotations") {
        let annotations = [Annotation(withString: "Face"), Annotation(withString: "Smile"), Annotation(withString: "Sad")]
        
        let emoji1 = Emoji.init(unicode: "X", emojiGlyph: "X", description: "grinning face",
          year: "2010", nature: "emoji",
          annotations: [Annotation(withString: "Face"), Annotation(withString: "Smile")])
        
        let emoji2 = Emoji.init(unicode: "X", emojiGlyph: "X", description: "grinning face with smiling eyes",
          year: "2010", nature: "emoji",
          annotations: [Annotation(withString: "Face"), Annotation(withString: "Sad")])
        
        let res = OWLGenerator.generateOWL(properties: Emoji.propertyDescriptors, annotations: annotations, emojis: [emoji1, emoji2])
        try! res.writeToFile("/Users/oabdelhafith/Desktop/x", atomically: false, encoding: NSUTF8StringEncoding)
        let mock = self.loadData("owl_full")
        
        expect(res).to(contain("#WordAnnotation"))
        expect(res).to(contain("#hasUsageNumber"))
        expect(res).to(contain("#AmericanAnnotation"))
        expect(res).to(contain("#ShortcakeAnnotation"))
      }
      
    }
    
    describe("Emoji") {
      
      it("can generate annotation owl") {
        let emoji = Emoji.init(unicode: "X", emojiGlyph: "X", description: "grinning face with smiling eyes",
          year: "2010", nature: "emoji",
          annotations: [Annotation(withString: "Face"), Annotation(withString: "Smile")])
        
        try! emoji.toOwlXML().writeToFile("/Users/oabdelhafith/Desktop/x", atomically: false, encoding: NSUTF8StringEncoding)
        expect(emoji.toOwlXML()) == self.loadData("owl_emoji")
        
      }
      
      it("returns the emoji web name") {
        let emoji1 =
        Emoji.init(unicode: "U+263A", emojiGlyph: "X", description: "grinning face with smiling eyes",
          year: "2010", nature: "emoji",
          annotations: [])
        
        expect(emoji1.webID) == "263A"
        
        let emoji2 =
        Emoji.init(unicode: "U+0023 U+20E3", emojiGlyph: "X", description: "grinning face with smiling eyes",
          year: "2010", nature: "emoji",
          annotations: [])
        
        expect(emoji2.webID) == "0023-20E3"
      }
      
      it("generates a csv row") {
        let emoji =
        Emoji.init(unicode: "U+263A", emojiGlyph: "X", description: "grinning face with smiling eyes",
          year: "2010", nature: "emoji",
          annotations: [Annotation(withString: "Face"), Annotation(withString: "Sad")])
        
        expect(emoji.toCSVString()) == "U+263A,X,grinning face with smiling eyes,2010,emoji,0,0.0,0.658098933074685,0.0,Face; Sad"
      }
      
    }
    
    describe("OWLNamer") {
      
      it("can generate emoji name") {
        expect(OWLNamer.prepareName("grinning face with smiling eyes")) == "GrinningFaceWithSmilingEyes"
      }
      
      it("name does not have colons") {
        expect(OWLNamer.prepareName("5:30")) == "5-30"
      }
      
      it("removes special characters") {
        expect(OWLNamer.prepareName("Name!")) == "Name"
        expect(OWLNamer.prepareName("#Name")) == "Name"
      }
      
    }
    
    describe("Annotation") {
      
      it("can generate annotation owl") {
        let annotation = Annotation(withString: "TheName")
        
        expect(annotation.toOwlXML()) == self.loadData("owl_annotation")
        
        let name1 = EmojiColorAnalyser.namedColor(Emoji(unicode: "", emojiGlyph: "😩", description: "", year: "", nature: "", annotations: []))
        let name2 = EmojiColorAnalyser.namedColor(Emoji(unicode: "", emojiGlyph: "🕗", description: "", year: "", nature: "", annotations: []))
        let name3 = EmojiColorAnalyser.namedColor(Emoji(unicode: "", emojiGlyph: "🌵", description: "", year: "", nature: "", annotations: []))
        
        expect(name1) == "Orange"
        expect(name2) == "White"
        expect(name3) == "Green"
      }
    }
    
    
    describe("EmojiUsageAnalyser") {
      
      it("analyses a use of an emoji") {
        
        let res = EmojiUsageAnalyser.parseEmojiText(self.loadData("MockEmojiUse", type: "txt"))
        expect(res.count) == 845
      }
      
      it("calculates uses of an emoji") {
        
        let analyser = EmojiUsageAnalyser(emojiText: self.loadData("MockEmojiUse", type: "txt"))
        expect(analyser["😟"]) == 15347745
      }
      
      it("calculates the average of an emoji") {
        
        let analyser = EmojiUsageAnalyser(emojiText: self.loadData("MockEmojiUse", type: "txt"))
        expect(analyser.percentageUsage("😟")).to(beCloseTo(0.11, within: 0.1))
      }
      
    }
    
    
    describe("Peroperty") {
      
      it("can generate property owl") {
        
        expect(OWLProperty(name: "nature", value: "", className: "", propertyType: .StringValue).toOwnDescriptorXML()) == self.loadData("owl_property")
      }
      
      it("can generate property owl with class and value") {
        
        expect(OWLProperty(name: "nature", value: "text", className: "Some1", propertyType: .StringValue).toOwlXML()) == self.loadData("owl_property_class_value")
      }
    }
    
  }
  
  func loadData(name: String, type: String = "xml") -> String {
    let path = NSBundle.init(forClass: self.dynamicType).pathForResource(name, ofType: type)!
    return try! String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
  }
  
}

