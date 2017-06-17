//
//  ProfileViewController.swift
//  InstaClone
//
//  Created by Relorie on 6/5/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate{
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameUILabel: UILabel!
    @IBOutlet weak var postCountUILabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postUsernameLabel: UIView!
    @IBOutlet weak var postProfileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        profileImageView.image = CurrentUser.profilePicture
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


