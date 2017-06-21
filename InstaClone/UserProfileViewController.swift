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
        loadUserData()
        presentUserData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUserData() {
        
    }
    
    func presentUserData() {
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        usernameLabel.text = user?.profileName
        profileImageView.image = user?.profilePicture
        handleFollowButton()
    }

    func followPressed() {
        guard user == nil else {
            SVProgressHUD.showError(withStatus: "Error initializing following user")
            return
        }
        Utilities.follow(user: user!)
        handleFollowButton()
    }
    
    @IBAction func followButtonPressed(_ sender: Any) {
        switch (followButton.titleLabel?.text)! {
            case "Follow":
                Utilities.follow(user: user!)
            case "Unfollow":
                Utilities.unfollow(user: user!)
            default:
                SVProgressHUD.showError(withStatus: "Error with follow button")
        }
    }
    
    fileprivate func handleFollowButton() {
        if (user?.isFollowedByCurrentUser)! {
            followButton.titleLabel?.text = "Unfollow"
        } else {
            followButton.titleLabel?.text = "Follow"
        }
    }
    
   
  
    
}
