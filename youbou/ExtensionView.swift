//
//  ExtensionView.swift
//  youbou
//
//  Created by Hans Yonathan on 9/10/2016.
//  Copyright © 2016 Hans Yonathan. All rights reserved.
//

import UIKit

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDisctionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDisctionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDisctionary))
    }
}

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageWithUrlString(urlString: String){
        let imageUrlString = URL(string: urlString)
        
        //set default image
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString){
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: imageUrlString!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: {
                let imageToCache = UIImage(data:data!)
                if self.imageUrlString == urlString{
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache!, forKey: urlString as NSString)
            })
            
        }).resume()
    }
}
