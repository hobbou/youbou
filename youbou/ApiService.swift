//
//  ApiService.swift
//  youbou
//
//  Created by Hans Yonathan on 22/10/2016.
//  Copyright © 2016 Hans Yonathan. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    func fetchVideos(completion: @escaping ([Video]) -> ()){
        fetchFeed(urlString: "\(baseUrl)/home.json", completion: completion)
    }
    
    func fetchTrendingFeed(completion: @escaping ([Video]) -> ()){
        fetchFeed(urlString: "\(baseUrl)/trending.json", completion: completion)
    }

    func fetchSubscriptionFeed(completion: @escaping ([Video]) -> ()){
        fetchFeed(urlString: "\(baseUrl)/subscriptions.json", completion: completion)
    }
    
    func fetchFeed(urlString: String, completion: @escaping ([Video]) ->()){
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            do{
                if let unwrappedData = data, let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [[String: AnyObject]]{
                    //add video data to video dict
                    let videos = jsonDictionaries.map({
                        return Video(dictionary: $0)
                    })
                    DispatchQueue.main.async(execute: {
                        //self.collectionView?.reloadData()
                        completion(videos)
                    })
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    
}
