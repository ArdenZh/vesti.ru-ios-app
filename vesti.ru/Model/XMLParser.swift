//
//  XMLParser.swift
//  vesti.ru
//
//  Created by Arden  on 07.07.2020.
//  Copyright © 2020 Arden Zhakhin. All rights reserved.
//

import Foundation
import UIKit

class Parser: NSObject, XMLParserDelegate{
    
    private var news: [News] = []
    private var currentElement = ""
    
    private var currentFullText: String = "" {
        didSet {
            currentFullText = currentFullText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }

    private var currentTitle: String = ""
    private var currentDate: String = ""
    private var currentImage: String? = ""
    private var currentCategory: String = ""
    private var currentUIImage: UIImage?
    
    private var parserCompletionHandler: (([News]) -> Void)?
    
    func parseFeed(url: String, completionHandler: (([News]) -> Void)?)
    {
        self.parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        
        task.resume()
    }
    
    // MARK: - parser delegate methods
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentFullText = ""
            currentDate = ""
            currentImage = nil
            currentCategory = ""
        }
        
        if currentElement == "enclosure" && currentImage == nil{
            if let attribute = attributeDict["url"]{
                currentImage = attribute
            }
        }
    }
        
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        switch currentElement {
        case "title": currentTitle += string
        case "pubDate" : currentDate += string
        case "yandex:full-text" : currentFullText += string
        case "category": currentCategory += string.capitalizingFirstLetter()
        default: break
        }
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == "item" {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
            
            if let dateFormat = formatter.date(from: currentDate){
                
                formatter.locale = Locale(identifier: "ru_RU")
                formatter.dateFormat = "d MMMM yyyy   HH:mm"
                currentDate = formatter.string(from: dateFormat)
            }
            if currentCategory == ""{
                currentCategory = "Разное"
            }
            
            if currentImage != nil{
                currentUIImage = showImage(URLinStringFormate: currentImage!)
            }else{
                currentUIImage = UIImage(named: "logo")
            }

            let rssItem = News(date: currentDate, title: currentTitle, fullText: currentFullText, imageURLInStringFormat: currentImage, UIimage: currentUIImage, category: currentCategory)
            self.news.append(rssItem)
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(news)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        print(parseError.localizedDescription)
    }
    
    
    //MARK: - image downloading from URL
    
    func showImage(URLinStringFormate: String) -> UIImage?{
        if let pubImageURL = URL(string: URLinStringFormate){
            do{
                let data = try Data(contentsOf: pubImageURL)
                let pubImage = UIImage(data: data)
                return pubImage
            }catch{
                print("Error with data downloading")
            }
        }
        return nil
    }
  
    
}


extension String{
    func capitalizingFirstLetter() -> String {
        return prefix(1).localizedCapitalized + self.localizedLowercase.dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}

