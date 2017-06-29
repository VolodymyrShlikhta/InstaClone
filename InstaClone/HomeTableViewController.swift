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
import ExpandableLabel

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
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let imageData = try? Data(contentsOf: URL(string: post.ownerProfilePictureURL)!) {
                    cell.profileImageView.image = UIImage(data: imageData)
                }
                
            }
            cell.post = post
            
            cell.backgroundColor = UIColor.white
            
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
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: URL(string: post.postPictureURL)!) {
                    newCell.postImageView.image = UIImage(data: imageData) 
                }
                
            }
            newCell.selectionStyle = .none
            newCell.post = post
            return newCell
        }
        return UITableViewCell()
    }
}

extension HomeTableViewController {
    func willExpandLabel(_ label: ExpandableLabel) {
        tableView.beginUpdates()
    }
    func didExpandLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.endUpdates()
    }
    func willCollapseLabel(_ label: ExpandableLabel) {
        tableView.beginUpdates()
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) as IndexPath? {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.endUpdates()
    }
   
}
