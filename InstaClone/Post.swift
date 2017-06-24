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
    var caption: String
    var photoURL: String
    var date: Date
    var profilePicture: UIImage?
    var profileName: String
    var likeCount: Int
    
    init (caption: String, photoURL: String,likeCount: Int, date: Date) {
        self.caption = caption
        self.photoURL = photoURL
        self.profilePicture = CurrentUser.sharedInstance.profilePicture
        self.profileName = CurrentUser.sharedInstance.profileName!
        self.likeCount = likeCount
        self.date = date
    }
}
