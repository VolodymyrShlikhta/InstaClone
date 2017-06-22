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
    var following: [String: Bool]
    var uid: String
    var isFollowingCurrentUser: Bool?
    
    init(uid: String, profilePictureURL: String, profileName: String, followers: [String: Bool], following: [String: Bool], isFollowingCurrentUser: Bool) {
        self.uid = uid
        self.profilePictureURL = profilePictureURL
        self.profileName = profileName
        self.followers = followers
        self.following = following
        self.isFollowingCurrentUser = isFollowingCurrentUser
    }
}
