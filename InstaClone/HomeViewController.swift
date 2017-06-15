//
//  HomeViewController.swift
//  InstaClone
//
//  Created by Relorie on 6/5/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        // loadPosts()
        // Do any additional setup after loading the view.
    }
    
    func loadPosts() {
        Database.database().reference().child("posts").observe(.childAdded) {(snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String:Any] {
                let captionText = dict["caption"] as? String
                let photoURL = dict["photoURL"] as? String
                let postDate = dict["timestamp"] as? Date
                let post = Post(caption: captionText!, photoURL: photoURL!, likeCount: 0, date: postDate!)
                self.posts.append(post)
                print("test")
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func performSignOut(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError {
            print(signOutError)
        }
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        newCell.textLabel?.text = posts[indexPath.row].caption
        return newCell
    }
}
