//
//  UserProfileViewController.swift
//  InstaClone
//
//  Created by Relorie on 6/20/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class UserProfileViewController: UIViewController {
    var user: User?
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var followedCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFollowButton()
        updateUiWithUserData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUiWithUserData() {
        usernameLabel.text = user?.profileName ?? "Error"
        profileImageView.image = user?.profilePicture
        followersCountLabel.text = user?.followersCount!.description
        followedCountLabel.text = user?.followingCount!.description
        postCountLabel.text = user?.postCount!.description
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUiWithUserData()
    }
    
    @IBAction func followButtonPressed(_ sender: Any) {
        switch (followButton.titleLabel?.text)! {
        case "Follow":
            Utilities.follow(user: user!)
            configureFollowButton()
            updateUiWithUserData()
        case "Unfollow":
            Utilities.unfollow(user: user!)
            configureFollowButton()
            updateUiWithUserData()
        default:
            SVProgressHUD.showError(withStatus: "Error with follow button")
        }
    }
    
    fileprivate func configureFollowButton() {
        if (user?.followedByCurrentUser) == true {
            self.followButton.setTitle("Unfollow", for: UIControlState.normal)
        } else {
            self.followButton.setTitle("Follow", for: UIControlState.normal)
        }
    }
}
