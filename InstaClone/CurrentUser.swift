//
//  User.swift
//  InstaClone
//
//  Created by Relorie on 6/12/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class CurrentUser {
    static var profilePicture: UIImage?
    static var profileName: String?
    static var postCount: Int {
        get {
            return posts.count
        } set {
            self.postCount = newValue
        }
    }
    static var posts = [Post]()
}
