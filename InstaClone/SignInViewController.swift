//
//  SignInViewController.swift
//  InstaClone
//
//  Created by Relorie on 6/4/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class SignInViewController: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.configureTextFieldsAppearence([emailTextField, passwordTextField])
        handleTextFields()
        signInButton.isEnabled = false
        signInButton.tintColor = .lightGray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "signInToTabbsVC", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func performSignIn(_ sender: UIButton) {
        view.endEditing(true)
        SVProgressHUD.show(withStatus: "Logging in...")
        AuthService.signIn(email: emailTextField.text!,
                           password: passwordTextField.text!,
                           onSuccess: { self.performSegue(withIdentifier: "signInToTabbsVC", sender: nil); SVProgressHUD.showSuccess(withStatus: "Welcome")},
                           onError: { error in SVProgressHUD.showError(withStatus: "\(error!)")}
                          )
    }
    
    func handleTextFields() {
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                signInButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
                signInButton.isEnabled = false
                return
        }
        signInButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        signInButton.isEnabled = true
    }
}
