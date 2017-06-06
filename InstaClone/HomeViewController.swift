//
//  HomeViewController.swift
//  InstaClone
//
//  Created by Relorie on 6/5/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func performSignOut(_ sender: UIBarButtonItem) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let signOutError {
            print(signOutError)
        }
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
