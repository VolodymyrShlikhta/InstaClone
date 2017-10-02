//
//  Post.swift
//  InstaClone
//
//  Created by Relorie on 6/11/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import Foundation
import UIKit

class Post {
    var ownerId: String
    var ownerName: String
    var ownerProfilePictureURL: URL?
    var date: Date
    var caption: String
    var postPictureURL: URL?
    var likeCount: Int {
        get {
            return self.liked.keys.count - 1
        }
    }
    var liked = [String:Bool]()
    
    init (ownerId: String, ownerName: String, ownerProfilePictureURL: URL?, date: Date, caption: String, postPictureURL: URL?, liked: [String:Bool]?) {
        self.ownerId = ownerId
        self.ownerName = ownerName
        self.ownerProfilePictureURL = ownerProfilePictureURL
        self.date = date
        self.caption = caption
        self.postPictureURL = postPictureURL
        self.liked = liked ?? [:]
    }
}
