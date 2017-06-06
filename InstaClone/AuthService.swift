//
//  AuthService.swift
//  InstaClone
//
//  Created by Relorie on 6/6/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthService
{
    class func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void)
    {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        })
    }
    class func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void)
    {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { ( user: FIRUser?, error: Error?) in
            if error != nil{
                onError(error!.localizedDescription)
                return
            }
            let uid = user?.uid
            let storageRef = FIRStorage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("profile_image").child((user?.uid)!)
            storageRef.put(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                let profileImageURL = metadata?.downloadURL()?.absoluteString
                
                self.setUserInfo(profileImageURL: profileImageURL!, username: username, email: email, uid: uid!, onSuccess: onSuccess)
            })
        })
    }
    
    class func setUserInfo(profileImageURL: String, username: String, email: String, uid: String, onSuccess: @escaping () -> Void){
        let databaseRef = FIRDatabase.database().reference()
        let userReference = databaseRef.child("users")
        let newUserReference = userReference.child(uid)
        newUserReference.setValue(["username" : username, "email" : email, "profileImageURL" : profileImageURL ])
        onSuccess()
        
    }
}
