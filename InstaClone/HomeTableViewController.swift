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
import SwiftyJSON
import SVProgressHUD

class HomeTableViewController: UITableViewController {
    @IBOutlet weak var postsTableView: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadAllPosts(refreshing: false, refreshControl: nil)
        // Do any additional setup after loading the view.
        print(posts)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(refreshControl, at: 0)
    }
    
    @objc func refreshControlAction(refreshControl: UIRefreshControl) {
        loadAllPosts(refreshing: true, refreshControl: refreshControl)
    }
    
    func loadAllPosts(refreshing: Bool, refreshControl: UIRefreshControl?) {
        let ref = Database.database().reference(withPath: "posts")
        SVProgressHUD.show(withStatus: "Loading posts...")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as? NSDictionary {
                if self.posts.count == Int(snapshot.childrenCount) {
                    if refreshing {
                        refreshControl?.endRefreshing()
                    }
                    SVProgressHUD.dismiss()
                    return
                }
                self.posts = []
                for item in dict {
                    let json = JSON(item.value)
                    let uid = json["uid"].stringValue
                    let name = json["ownerName"].stringValue
                    let profilePicURL = json["ownerPhotoURL"].stringValue
                    let caption: String = json["caption"].stringValue
                    let postPicURL: String = json["postPhotoURL"].stringValue
                    let timestamp = json["timestamp"].doubleValue
                    let date = Date(timeIntervalSince1970: timestamp/1000)
                    let liked = json["liked"].rawValue as? [String:Bool]
                    let post = Post(ownerId: uid, ownerName: name, ownerProfilePictureURL: profilePicURL, date: date, caption: caption, postPictureURL: postPicURL, liked: liked)
                    self.posts.append(post)
                    
                    self.posts.sort {$0.date.compare($1.date) == .orderedDescending}
                    self.tableView.reloadData()
                    
                }
            }
            if refreshing {
                refreshControl?.endRefreshing()
            }
            SVProgressHUD.dismiss()
        })
        SVProgressHUD.dismiss()
    }
}

extension HomeTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let newCell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell {
            let post = posts[indexPath.row]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: post.date)
            newCell.postCaptionTextView.text = post.caption
            newCell.postDateLabel.text = dateString
            newCell.usernameLabel.text = post.ownerName
            
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: URL(string: post.ownerProfilePictureURL)!) {
                    newCell.profileImageView.image = UIImage(data: imageData) ?? UIImage(contentsOfFile: "placeholder_camera")
                }
                
            }
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: URL(string: post.postPictureURL)!) {
                    newCell.postImageView.image = UIImage(data: imageData) ?? UIImage(contentsOfFile: "placeholder_camera")
                }
                
            }
            return newCell
        }
        return UITableViewCell()
    }
}
