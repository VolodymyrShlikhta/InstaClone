//
//  SignUpViewController.swift
//  InstaClone
//
//  Created by Relorie on 6/4/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.configureTextFieldAppearence(for: usernameTextField)
        Utilities.configureTextFieldAppearence(for: emailTextField)
        Utilities.configureTextFieldAppearence(for: passwordTextField)
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        
   }

    @IBAction func dismissOnClick(_ sender: UIButton) {
         dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
