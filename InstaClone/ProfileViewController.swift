//
//  ProfileViewController.swift
//  InstaClone
//
//  Created by Relorie on 6/5/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameUILabel: UILabel!
    @IBOutlet weak var postCountUILabel: UILabel!
    @IBOutlet weak var postsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        profileImageView.image = CurrentUser.profilePicture
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrentUser.postCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        newCell.textLabel?.text = "asd"
        return newCell
    }
}
