//
//  PostsTableViewController.swift
//  InstaClone
//
//  Created by Relorie on 6/17/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SVProgressHUD
import SwiftyJSON

class PostsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrentUser.sharedInstance.postCount ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostsTableViewCell
        /*let newPost = CurrentUser.posts[indexPath.row]
        let caption = newPost.caption
        let downloadURL = newPost.photoURL
        let date = newPost.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)*/
        
       
        
        return cell
    }

}
