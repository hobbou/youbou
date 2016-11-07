//
//  Video.swift
//  youbou
//
//  Created by Hans Yonathan on 9/10/2016.
//  Copyright © 2016 Hans Yonathan. All rights reserved.
//

import UIKit

class SaveJsonObject: NSObject {
    
    override func setValue(_ value: Any?, forKey key: String) {
        let upperCasedFirstCharacter = String(key.characters.first!).uppercased()
        let range = key.startIndex..<key.characters.index(key.startIndex, offsetBy: 1)
        let selectorString = key.replacingCharacters(in: range, with: upperCasedFirstCharacter)
        print(selectorString)
        let selector = NSSelectorFromString("set\(selectorString):")
        let responds = self.responds(to: selector)
        
        if !responds {
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
}

class Video: SaveJsonObject {
    var thumbnail_image_name: String?
    var title: String?
    var number_of_views: NSNumber?
    var uploadDate: NSDate?
    var duration: NSNumber?
    var channel: Channel?
    //var num_likes: NSNumber?
    
    override func setValue(_ value: Any?, forKey key: String) {        
        if key == "channel" {
            self.channel = Channel()
            self.channel?.setValuesForKeys(value as! [String: AnyObject])
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dictionary)
    }
    
}
