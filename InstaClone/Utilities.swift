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
        CurrentUser.sharedInstance.profilePicture = newProfilePicture
        CurrentUser.sharedInstance.profileName = newProfileName
        CurrentUser.sharedInstance.uid = (Auth.auth().currentUser?.uid)!
    }
    
    class func getFromDatabaseUserInfo(forUser user: User, withUid uid: String, downloadProfileImage: Bool) {
        let ref = Database.database().reference()
        user.uid = uid

        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
            let username = value["username"] as? String ?? ""
            user.profileName = username
            user.postCount = value["postCount"] as? Int
            user.followers = value["followers"] as! [String:Bool]
            user.following = value["following"] as! [String:Bool]
            let profileImageURL = value["profileImageURL"] as? String
            user.profilePictureURL = profileImageURL
            if downloadProfileImage == true {
                Utilities.downloadInBackground(url: profileImageURL,forUser: user)
            }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    fileprivate class func downloadInBackground(url : String?,forUser user: User) {
        if let profileImageURL = url {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: URL(string: profileImageURL)!) {
                    user.profilePicture =  UIImage(data: imageData)
                }
            }
        }
    }
    
    class func follow(user userToFollow: User) {
        let databaseRef = Database.database().reference()
        databaseRef.child("users/\(userToFollow.uid!)/followers").child(CurrentUser.sharedInstance.uid!).setValue(true)
        databaseRef.child("users/\(CurrentUser.sharedInstance.uid!)/following/").child(userToFollow.uid!).setValue(true)
        userToFollow.followers[CurrentUser.sharedInstance.uid!] = true
        userToFollow.followedByCurrentUser = true
        CurrentUser.sharedInstance.following[userToFollow.uid!] = true
        SVProgressHUD.showSuccess(withStatus: "User followed!")
    }
    
    class func unfollow(user : User) {
        let databaseRef = Database.database().reference()
        databaseRef.child("users/\(user.uid!)/followers/").child(CurrentUser.sharedInstance.uid!).removeValue()
        databaseRef.child("users/\(CurrentUser.sharedInstance.uid!)/following/").child(user.uid!).removeValue()
        user.followers.removeValue(forKey: CurrentUser.sharedInstance.uid!)
        user.followedByCurrentUser = false
        CurrentUser.sharedInstance.following.removeValue(forKey: user.uid!)
        SVProgressHUD.showSuccess(withStatus: "User unfollowed!")
    }
}
