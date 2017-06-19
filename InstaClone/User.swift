//
//  User.swift
//  InstaClone
//
//  Created by Relorie on 6/19/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import Foundation

class User {
    var profilePictureURL: String
    var profileName: String
    var posts: [Post]
    var followers: [String]
    var followed: [String]
    
    init(profilePictureURL: String, profileName: String, posts: [Post], followers: [String], followed: [String]) {
        self.profilePictureURL = profilePictureURL
        self.profileName = profileName
        self.posts = posts
        self.followers = followers
        self.followed = followed
    }
    
    init(profilePictureURL: String, profileName: String){
        self.profilePictureURL = profilePictureURL
        self.profileName = profileName
        self.posts = []
        self.followers = []
        self.followed = []
    }
}
