//
//  User.swift
//  InstaClone
//
//  Created by Relorie on 6/12/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import Foundation
import UIKit

class CurrentUser {
    static var profilePicture: UIImage?
    static var profileName: String?
    static var postCount: Int? {
        get {
            return posts.count 
        } 
    }
    static var uid: String?
    static var posts = [Post]()
    static var followers = [String: Bool]()
    static var following = [String: Bool]()
}
