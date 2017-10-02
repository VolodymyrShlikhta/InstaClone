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
    
    struct Storyboard {
        static let postCell = "postCell"
        static let postHeaderCell = "postHeaderCell"
        static let postHeaderHeight: CGFloat = 57.0
        static let postCellDefaultHeight: CGFloat = 500.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        postsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadAllPosts(refreshing: false, refreshControl: nil)
        setupRefreshControl()
        postsTableView.estimatedRowHeight = Storyboard.postCellDefaultHeight
        postsTableView.rowHeight = UITableViewAutomaticDimension
        postsTableView.separatorColor = UIColor.clear
    }
    
    fileprivate func setupRefreshControl() {
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
                    let profilePicURL = URL(string: json["ownerPhotoURL"].stringValue)
                    let caption: String = json["caption"].stringValue
                    let postPicURL = URL(string: json["postPhotoURL"].stringValue)
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Storyboard.postHeaderHeight
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.postHeaderCell) as? PostHeaderTableViewCell {
            let post = self.posts[section]
            cell.profileImageView.kf.indicatorType = .activity
            if let downloadURL = post.ownerProfilePictureURL {
                cell.profileImageView.kf.setImage(with: downloadURL)
            } else {
                cell.profileImageView.image = UIImage(named: "Profile.png")
            }
            cell.post = post
            
            cell.backgroundColor = UIColor.white
            tableView.endUpdates()
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let newCell = tableView.dequeueReusableCell(withIdentifier: Storyboard.postCell, for: indexPath) as? PostTableViewCell {
            let post = posts[indexPath.section]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: post.date)
            newCell.postImageView.image = nil
            newCell.postImageView.kf.indicatorType = .activity
            if let downloadURL = post.postPictureURL {
                newCell.postImageView.kf.setImage(with: downloadURL)
            } else {
                newCell.postImageView.image = UIImage(named: "Profile.png")
            }
            newCell.post = post
            newCell.likeButtonHandler = {()-> Void in
               //if()
            }
            return newCell
        }
        return UITableViewCell()
    }
}
