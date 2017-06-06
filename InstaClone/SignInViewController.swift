//
//  SignInViewController.swift
//  InstaClone
//
//  Created by Relorie on 6/4/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.configureTextFieldsAppearence([emailTextField, passwordTextField])
        handleTextFields()
        signInButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FIRAuth.auth()?.currentUser != nil {
            self.performSegue(withIdentifier: "signInToTabbsVC", sender: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func performSignIn(_ sender: UIButton) {
        AuthService.signIn(email: emailTextField.text!,
                           password: passwordTextField.text!,
                           onSuccess: { self.performSegue(withIdentifier: "signInToTabbsVC", sender: nil) },
                           onError: { error in print(error!) }
        )
    }
    
    // TODO: Refactor handleTextFields()
    func handleTextFields() {
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signInButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            signInButton.isEnabled = false
            return
        }
        signInButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        signInButton.isEnabled = true
    }
}
