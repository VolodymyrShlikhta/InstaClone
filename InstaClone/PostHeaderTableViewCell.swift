//
//  PostHeaderTableViewCell.swift
//  InstaClone
//
//  Created by Relorie on 6/27/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit

class PostHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var post: Post! {
        didSet {
            self.updateUI()
        }
    }
    
    fileprivate func updateUI() {
        profileImageView.image = post.ownerProfilePicture
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        usernameLabel.text = post.ownerName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
