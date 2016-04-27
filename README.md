# Emoji Ontology

<p align="center">
<img src="http://cdn.makeuseof.com/wp-content/uploads/2015/06/2_emoji.png?2047b0" width="450" align="middle"/>
<br/>
</p>
<br/>

Emoji ontology is a mac application that analyses emojis.

EmojiOntology adds the following meta-ata to emojis:

- Color analysis
- Usage number analysis
- Sentiment analysis
- Additional emoji annotation categories

<p align="center">
<img src="https://raw.githubusercontent.com/oarrabi/EmojiOntology/master/res/color.png?token=ABZLPA_xMzrws-DikiFONlzMM2SiD214ks5XIqa1wA%3D%3D" width="550" align="middle"/>
<br/>
</p>

It then converts the analysis to the following:

- CSV format
- OWL/XML ontology format

## Documentation
Code documentation can be found here on [github pages](http://oarrabi.github.io/EmojiOntology/).

-----
## Analyzing emojis

### Color analysis
The color analysis aims to get the dominant color for each emoji. It does that by using `dither` command in `imageMagick` utility.

### Usage analysis
The usage analysis calculates the usage of each emoji in twitter. The numbers are read and parsed from [emojitracker.com](http://emojitracker.com/).

### Sentiment analysis
The sentiment analysis aim to provide the sentiment for each emoji. The sentiment is calculated by analyzing the number of occurrence an emoji has been used in a negative, positive and neutral contexts.

### Emoji annotations additional categories
When exporting to OWL, EmojiOntology applies an additional level of categories on the emoji annotations.

-----

## Exporting analysis

### Exporting to CSV
Exports the emoji meta-data to CSV file.

### Exporting to OWL/XML
Exports the emoji ontology to OWL/XML format.

-----

## Resources

This is a list of files and what they represent

[Annotation Categories.csv](https://github.com/oarrabi/EmojiOntology/blob/master/deliverables/Annotation%20Categories.csv): 
This file contains the annotation additional categories, these categories help giving the emoji another depth in the ontology structure.

[AnnotationCategories.xml](https://github.com/oarrabi/EmojiOntology/blob/master/res/AnnotationCategories.xml): 
File containing a template OWL/XML file for all the additional category subclassing information.

[Emoji.owl](https://github.com/oarrabi/EmojiOntology/blob/master/res/Emoji.owl): 
Emoji OWL main file template. This file contains placeholder string markers that EmojiOntology app fills when generating the final emoji.

[EmojiColor.plist](https://github.com/oarrabi/EmojiOntology/blob/master/deliverables/EmojiColor.plist): Mac property list (mac dictionary) file that contains a hash map dictionary, with emoji as key and emoji dominant color as value.

[EmojiFull.csv](https://github.com/oarrabi/EmojiOntology/blob/master/deliverables/EmojiFull.csv): CSV file containing a list of emoji and all the meta-data available for each emoji.

[EmojiUses.plist](https://github.com/oarrabi/EmojiOntology/blob/master/deliverables/EmojiUses.plist): Mac property list (mac dictionary) file that contains a hash map dictionary, with emoji as key and emoji twitter usage numbers as value.

[Sentiment.csv](https://github.com/oarrabi/EmojiOntology/blob/master/deliverables/Sentiment.csv): CSV file containing the emoji base unicode information.

-----

## Notable Classes
The following is a rundown of the classes used in the application.

Note: The complete code documentation can be found here on [github pages](http://oarrabi.github.io/EmojiOntology/).

### AdditionalCategories
`AdditionalCategories.swift`: Class responsible to parse and enrich the emoji annotations with additional structural levels.
- [Github link](https://github.com/oarrabi/EmojiOntology/blob/master/EmojiAnalyzer/Analysis/AdditionalCategories/AdditionalCategories.swift) 
- [Documentation link](http://oarrabi.github.io/EmojiOntology/Classes/AdditionalCategories.html)

### Colors
`EmojiColorAnalyser.swift`: Class responsible to analyze the colors of an emoji.
- [Github link](https://github.com/oarrabi/EmojiOntology/blob/master/EmojiAnalyzer/Analysis/Color/EmojiColorAnalyser.swift)
- [Documentation](http://oarrabi.github.io/EmojiOntology/Classes/EmojiColorAnalyser.html)

`EmojiDrawer.swift`: Class responsible to draw an emoji to an image.
- [Github link](https://github.com/oarrabi/EmojiOntology/blob/master/EmojiAnalyzer/Analysis/Color/EmojiDrawer.swift)
- [Documentation](http://oarrabi.github.io/EmojiOntology/Classes/EmojiDrawer.html)


### Sentiment
`SentimentAnalyzer.swift`: Singleton to access the `SentimentAnalyzer`.
- [Github link](https://github.com/oarrabi/EmojiOntology/blob/master/EmojiAnalyzer/Analysis/Sentiment/SentimentAnalyzer.swift)
- [Documentation](http://oarrabi.github.io/EmojiOntology/Classes/SentimentAnalyzer.html)

`SentimentItem.swift`: Sentiment item containing all info about an emoji sentiment.
- [Github link](https://github.com/oarrabi/EmojiOntology/blob/master/EmojiAnalyzer/Analysis/Sentiment/SentimentItem.swift)
- [Documentation](http://oarrabi.github.io/EmojiOntology/Classes/SentimentItem.html)

`StreamReader.swift`: Read a file as a stream (buffered reading).
- [Github link](https://github.com/oarrabi/EmojiOntology/blob/master/EmojiAnalyzer/Analysis/Sentiment/StreamReader.swift)
- [Documentation](http://oarrabi.github.io/EmojiOntology/Classes/StreamReader.html)

### Usage Numbers
`EmojiUsageAnalyser.swift`: Class responsible for analysing the emoji usage.
- [Github link](https://github.com/oarrabi/EmojiOntology/blob/master/EmojiAnalyzer/Analysis/Usage/EmojiUsageAnalyser.swift)
- [Documentation](http://oarrabi.github.io/EmojiOntology/Structs/EmojiUsageAnalyser.html)

`WebViewLoader.swift`: This class starts a web kit view in the background and uses mac javascript bridge to read 
 values from the loaded webpage dom.
- [Github link](https://github.com/oarrabi/EmojiOntology/blob/master/EmojiAnalyzer/Analysis/Usage/WebViewLoader.swift)
- [Documentation](http://oarrabi.github.io/EmojiOntology/Classes/WebViewLoader.html)

### Emoji Reader
`EmojiReader.swift`: Class responsible for reading the emoji Unicode CSV and parse it to annotations and emojis
- [Github link](https://github.com/oarrabi/EmojiOntology/blob/master/EmojiAnalyzer/EmojiReader/EmojiReader.swift)
- [Documentation](http://oarrabi.github.io/EmojiOntology/Classes/EmojiReader.html)

### CSV Generation
`CSVConvertible.swift`: Protocol to convert objects to CSV.
- [Github link](https://github.com/oarrabi/EmojiOntology/blob/master/EmojiAnalyzer/Generators/CSV/CSVConvertible.swift)
- [Documentation](http://oarrabi.github.io/EmojiOntology/Protocols/CSVConvertible.html)

`CSVGenerator.swift`: Class responsible to generate a CSV string.
- [Github link](https://github.com/oarrabi/EmojiOntology/blob/master/EmojiAnalyzer/Generators/CSV/CSVGenerator.swift)
- [Documentation](http://oarrabi.github.io/EmojiOntology/Classes/EmojiReader.html)

### OWL Generation
`OWLConvertible.swift`: Protocol defining the requirements for an object to be convertible to OWL.
- [Github link](https://github.com/oarrabi/EmojiOntology/blob/master/EmojiAnalyzer/Generators/OWL/OWLConvertible.swift)
- [Documentation](http://oarrabi.github.io/EmojiOntology/Protocols/OWLConvertible.html)

`OWLGenerator.swift`: Generates an OWL file with the Emoji info.
- [Github link](https://github.com/oarrabi/EmojiOntology/blob/master/EmojiAnalyzer/Generators/OWL/OWLGenerator.swift)
- [Documentation](http://oarrabi.github.io/EmojiOntology/Classes/OWLGenerator.html)

`OWLNamer.swift`: Class responsible to sanitize a string to be usable as an OWL entity name.
- [Github link](https://github.com/oarrabi/EmojiOntology/blob/master/EmojiAnalyzer/Generators/OWL/OWLNamer.swift)
- [Documentation](http://oarrabi.github.io/EmojiOntology/Classes/OWLNamer.html)

### Models
`Annotation.swift`: Annotation class representing an emoji annotation (face, eyes, mouth, etc..).
- [Github link](https://github.com/oarrabi/EmojiOntology/blob/master/EmojiAnalyzer/Models/Annotation.swift)
- [Documentation](http://oarrabi.github.io/EmojiOntology/Classes/Annotation.html)

`Emoji.swift`: Emoji class representing an emoji.
- [Github link](https://github.com/oarrabi/EmojiOntology/blob/master/EmojiAnalyzer/Models/Emoji.swift)
- [Documentation](http://oarrabi.github.io/EmojiOntology/Classes/Emoji.html)

