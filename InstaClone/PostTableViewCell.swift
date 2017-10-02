//
//  PostsTableViewCell.swift
//  InstaClone
//
//  Created by Relorie on 6/19/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import Kingfisher

class PostTableViewCell: UITableViewCell {
    var likeButtonHandler:(()-> Void)!

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionExpandableLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var post: Post! {
        didSet {
            self.updateUI()
        }
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        self.likeButtonHandler()
    }
    
    fileprivate func updateUI() {
        postImageView.kf.setImage(with: post.postPictureURL)
        captionExpandableLabel.text = post.caption
        if post.likeCount == 1 {
            likeCountLabel.text = "♥ 1 Like"
        } else {
            likeCountLabel.text = "♥ \(post.likeCount) Likes"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
