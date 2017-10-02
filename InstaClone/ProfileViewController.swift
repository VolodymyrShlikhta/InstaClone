//
//  ProfileViewController.swift
//  InstaClone
//
//  Created by Relorie on 6/5/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var follow_editProfileButton: UIButton!
    @IBOutlet weak var usernameUILabel: UILabel!
    @IBOutlet weak var postCountUILabel: UILabel!
    @IBOutlet weak var followersCountUILablel: UILabel!
    @IBOutlet weak var followedCountUILabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        let url = URL(string: CurrentUser.sharedInstance.uid!)
        profileImageView.kf.setImage(with: url)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUiWithUserData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUiWithUserData() {
        usernameUILabel.text = CurrentUser.sharedInstance.profileName ?? "Error"
        if let profileImage =  CurrentUser.sharedInstance.profileImage {
            profileImageView.image = profileImage
        } else {
            profileImageView.image = UIImage(named: "Profile.png")
        }
        followersCountUILablel.text = "Followers:" + (CurrentUser.sharedInstance.followersCount?.description ?? "Error")
        followedCountUILabel.text = "Following:" + (CurrentUser.sharedInstance.followingCount?.description ?? "Error")
        postCountUILabel.text = "Posts:" + (CurrentUser.sharedInstance.postCount?.description ?? "Error")
    }
    
    @IBAction func performSignOut(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError {
            print(signOutError)
        }
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
    }
}


