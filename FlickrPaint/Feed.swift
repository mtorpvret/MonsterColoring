//
//  Feed.swift
//  PhotoFeed
//
//  Amended for MonsterColoring, to find the large pic and not just previews
//
//  Created by Mike Spears on 2016-01-08.
//  Copyright © 2016 YourOganisation. All rights reserved.
//
//

import Foundation

struct FeedItem {
    let title: String
    let previewURL: NSURL
    let imageURL: NSURL
}

func fixJsonData (data: NSData) -> NSData {
    var dataString = String(data: data, encoding: NSUTF8StringEncoding)!
    dataString = dataString.stringByReplacingOccurrencesOfString("\\'", withString: "'")
    return dataString.dataUsingEncoding(NSUTF8StringEncoding)!
    
}


class Feed {
    
    let items: [FeedItem]
    let sourceURL: NSURL
    
    init (items newItems: [FeedItem], sourceURL newURL: NSURL) {
        self.items = newItems
        self.sourceURL = newURL
    }
    
    convenience init? (data: NSData, sourceURL feedURL: NSURL) {
        
        var newItems = [FeedItem]()
        
        let fixedData = fixJsonData(data)
        
        var jsonObject: Dictionary<String, AnyObject>?
        
        do {
            jsonObject = try NSJSONSerialization.JSONObjectWithData(fixedData, options: NSJSONReadingOptions(rawValue: 0)) as? Dictionary<String,AnyObject>
        } catch {
            
        }
        
        guard let feedRoot = jsonObject else {
            return nil
        }
        
        guard let items = feedRoot["items"] as? Array<AnyObject>  else {
            return nil
        }
        
        
        for item in items {
            
            guard let itemDict = item as? Dictionary<String,AnyObject> else {
                continue
            }
            guard let media = itemDict["media"] as? Dictionary<String, AnyObject> else {
                continue
            }
            
            guard let urlString = media["m"] as? String else {
                continue
            }
            
            guard let previewURL = NSURL(string: urlString) else {
                continue
            }

            var s = urlString.characters
            let index = s.endIndex.advancedBy(-6)
            if s[index] == "_" && s[index.successor()] == "m" {
                s.removeRange(Range(start: index, end: index.advancedBy(2)))
            }
            
            guard let imageURL = NSURL(string: String(s)) else {
                continue
            }
            
            let title = itemDict["title"] as? String
            
            newItems.append(FeedItem(title: title ?? "(no title)", previewURL: previewURL, imageURL: imageURL))
            
        }
        
        self.init(items: newItems, sourceURL: feedURL)
    }
    
}