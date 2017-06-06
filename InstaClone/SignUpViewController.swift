//
//  SignUpViewController.swift
//  InstaClone
//
//  Created by Relorie on 6/4/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController
{
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.configureTextFieldAppearence(for: usernameTextField)
        Utilities.configureTextFieldAppearence(for: emailTextField)
        Utilities.configureTextFieldAppearence(for: passwordTextField)
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        let profileImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectProfileImageView ))
        profileImageView.addGestureRecognizer(profileImageTapGesture)
        profileImageView.isUserInteractionEnabled = true
    }
    
    func handleTextField() {
        usernameTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    func textFieldDidChange() {
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signUpButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            signUpButton.isEnabled = false
            return
        }
        signUpButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        signUpButton.isEnabled = true
    }
    
    @IBAction func performSignUp(_ sender: UIButton) {
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { ( user: FIRUser?, error: Error?) in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            let uid = user?.uid
            let storageRef = FIRStorage.storage().reference(forURL: "gs://instaclone-4343a.appspot.com").child("profile_image").child((user?.uid)!)
            if let profileImage = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
                storageRef.put(imageData, metadata: nil, completion: { (metadata, error) in
                   
                    if error != nil {
                        return
                    }
                    let profileImageURL = metadata?.downloadURL()?.absoluteString
                    
                 self.setUserInfo(profileImageURL: profileImageURL!, username: self.usernameTextField.text!, email: self.emailTextField.text!, uid: uid!)
               })
            }
            
        })
        
    }
    
    func setUserInfo(profileImageURL: String, username: String, email: String, uid: String){
        let databaseRef = FIRDatabase.database().reference()
        let userReference = databaseRef.child("users")
        let newUserReference = userReference.child(uid)
        newUserReference.setValue(["username" : username, "email" : email, "profileImageURL" : profileImageURL ])
    }
    
    @IBAction func dismissOnClick(_ sender: UIButton) {
         dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any] ) {
        if let newProfileImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = newProfileImage
            profileImageView.image = newProfileImage
            
        }
        dismiss(animated: true, completion: nil)
    }
    
}

