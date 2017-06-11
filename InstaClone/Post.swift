//
//  Post.swift
//  InstaClone
//
//  Created by Relorie on 6/11/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import Foundation

class Post
{
    let caption: String
    let photoURL: String
    
    init (caption: String, photoURL: String) {
        self.caption = caption
        self.photoURL = photoURL
    }
}
