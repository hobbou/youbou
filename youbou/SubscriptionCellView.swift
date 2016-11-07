//
//  SubscriptionCell.swift
//  youbou
//
//  Created by Hans Yonathan on 1/11/2016.
//  Copyright © 2016 Hans Yonathan. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {

    override func fetchVideos() {
        ApiService.sharedInstance.fetchSubscriptionFeed { (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }

}
