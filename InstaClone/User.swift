//
//  User.swift
//  InstaClone
//
//  Created by Relorie on 6/19/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import Foundation
import UIKit

class User {
    var profilePictureURL: String
    var profilePicture: UIImage?
    var profileName: String
    var posts = [Post]()
    var followers: [String: Bool]
    var followed: [String: Bool]
    var uid: String
    var isFollowedByCurrentUser: Bool?
    
    init(uid: String, profilePictureURL: String, profileName: String, followers: [String: Bool], followed: [String: Bool], isFollowedByCurrentUser: Bool) {
        self.uid = uid
        self.profilePictureURL = profilePictureURL
        self.profileName = profileName
        self.followers = followers
        self.followed = followed
        self.isFollowedByCurrentUser = isFollowedByCurrentUser
    }
}
