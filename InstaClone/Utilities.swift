//
//  Utilities.swift
//  InstaClone
//
//  Created by Relorie on 6/6/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import FirebaseAuth
import FirebaseDatabase

class Utilities {
    class func configureTextFieldsAppearence(_ textFields: [UITextField]) {
        for textField in textFields {
            textField.backgroundColor = UIColor.clear
            textField.tintColor = UIColor.white
            textField.textColor = UIColor.white
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor(white :1.0, alpha: 0.6)])
            let bottomLayer: CALayer = CALayer()
            bottomLayer.frame = CGRect(x:0 ,y:29, width:1000, height: 5)
            bottomLayer.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1).cgColor
            textField.layer.addSublayer(bottomLayer)
        }
    }
    
    class func configureSVProgressHUDDefaultValues() {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setFadeInAnimationDuration(0.5)
        SVProgressHUD.setFadeOutAnimationDuration(0.5)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
        SVProgressHUD.setMaximumDismissTimeInterval(2)
    }
    
    class func setNewCurrentUserInfo(newProfilePicture: UIImage, newProfileName: String) {
        CurrentUser.profilePicture = newProfilePicture
        CurrentUser.profileName = newProfileName
        CurrentUser.uid = Auth.auth().currentUser?.uid
    }
    
    class func setNewCurrentUserInfo() {
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        CurrentUser.uid = userID
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            CurrentUser.profileName = username
            CurrentUser.followers = ((value?["followers"] as? NSDictionary) as? [String:Bool])!
            CurrentUser.following = ((value?["following"] as? NSDictionary) as? [String:Bool])!
            let profileImageURL = value?["profileImageURL"] as? String
            
            Utilities.downloadInBackground(url : profileImageURL)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    fileprivate class func downloadInBackground(url : String?) {
        if let profileImageURL = url {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: URL(string: profileImageURL)!) {
                    CurrentUser.profilePicture = UIImage(data: imageData)
                }
            }
        }
    }
    
    class func follow(user userToFollow: User) {
        let databaseRef = Database.database().reference()
        databaseRef.child("users/\(userToFollow.uid)/followers").child(CurrentUser.uid!).setValue(true)
        databaseRef.child("users/\(CurrentUser.uid!)/following/").child(userToFollow.uid).setValue(true)
        SVProgressHUD.showSuccess(withStatus: "User followed!")
    }
    
    class func unfollow(user userToUnfollow: User) {
        let databaseRef = Database.database().reference()
        databaseRef.child("users/\(userToUnfollow.uid)/followers/").child(CurrentUser.uid!).removeValue()
        databaseRef.child("users/\(CurrentUser.uid!)/following/").child(userToUnfollow.uid).removeValue()
        userToUnfollow.isFollowingCurrentUser = false
        SVProgressHUD.showSuccess(withStatus: "User unfollowed!")
    }
}
