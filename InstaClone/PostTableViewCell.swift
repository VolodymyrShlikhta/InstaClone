//
//  PostsTableViewCell.swift
//  InstaClone
//
//  Created by Relorie on 6/19/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import ExpandableLabel

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionExpandableLabel: ExpandableLabel!
    
    
    @IBOutlet weak var likeCountLabel: UILabel!
    var post: Post! {
        didSet {
            self.updateUI()
        }
    }
    
    fileprivate func updateUI() {
        postImageView.image = post.postPicture
        captionExpandableLabel.text = post.caption
        captionExpandableLabel.collapsedAttributedLink = NSAttributedString(string: "See more...")
        captionExpandableLabel.numberOfLines = 3
        if post.likeCount == 1 {
            likeCountLabel.text = "♥ 1 Like"
        } else {
            likeCountLabel.text = "♥ \(post.likeCount) Likes"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        captionExpandableLabel.setLessLinkWith(lessLink: "Collapse", attributes: [NSForegroundColorAttributeName: UIColor.black], position: NSTextAlignment.natural)
        captionExpandableLabel.numberOfLines = 3
        captionExpandableLabel.collapsed = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
