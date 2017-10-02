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
    var profilePictureURL: URL?
    var profileName: String?
    var posts = [Post]()
    var postCount: Int? {
        get {
            return self.posts.count
        } set { }
    }
    var followers = [String: Bool]()
    var following =  [String: Bool]()
    var uid: String?
    var followedByCurrentUser: Bool?
    var followersCount: Int? {
        get {
            return self.followers.keys.count - 1
        }
    }
    var followingCount: Int? {
        get {
            return self.following.keys.count - 1
        }
    }
    var profileImage: UIImage?
    
    init(uid: String?, profilePictureURL: URL?, profileName: String?, followers: [String: Bool]?, following: [String: Bool]?, postCount: Int?, isFollowingCurrentUser: Bool?) {
        self.uid = uid
        self.profilePictureURL = profilePictureURL
        self.profileName = profileName
        self.followers = followers ?? [:]
        self.following = following ?? [:]
        self.followedByCurrentUser = isFollowingCurrentUser
        self.postCount = postCount
    }
    
    convenience init() {
       self.init(uid: nil, profilePictureURL: nil, profileName: nil, followers: nil, following: nil, postCount: nil, isFollowingCurrentUser: nil)
    }
}
