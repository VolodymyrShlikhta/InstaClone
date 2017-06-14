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
import SVProgressHUD

class SignUpViewController: UIViewController {
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.configureTextFieldsAppearence([emailTextField,usernameTextField,passwordTextField])
        configureImageView()
        handleTextFields()
        signUpButton.isEnabled = false
    }
    
    func configureImageView() {
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        let profileImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImageView ))
        profileImageView.addGestureRecognizer(profileImageTapGesture)
        profileImageView.isUserInteractionEnabled = true
    }
    
    func handleTextFields() {
        usernameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func performSignUp(_ sender: UIButton) {
        view.endEditing(true)
        SVProgressHUD.show(withStatus: "Waiting...")
        if let profileImage = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImage, 0.1) {
            let username = self.usernameTextField.text!
            AuthService.signUp(username: usernameTextField.text!,
                               email: emailTextField.text!,
                               password: passwordTextField.text!,
                               imageData: imageData,
                               onSuccess: { self.performSegue(withIdentifier: "signUpToTabbsVC",sender: nil); SVProgressHUD.showSuccess(withStatus: "Welcome, \(username)!"); Utilities.setNewCurrentUserInfo(newProfilePicture: profileImage, newProfileName: username)},
                               onError: { (errorString) in SVProgressHUD.showError(withStatus: "\(errorString!)") }
            )
        } else {
            SVProgressHUD.showError(withStatus: "Profile must have a picture.")
        }
    }
    
    
    @IBAction func dismissOnClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any] ) {
        if let newProfileImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = newProfileImage
            profileImageView.image = newProfileImage
        }
        dismiss(animated: true, completion: nil)
    }
    
}
