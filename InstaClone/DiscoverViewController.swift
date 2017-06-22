//
//  DiscoverViewController.swift
//  InstaClone
//
//  Created by Relorie on 6/5/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON
import SVProgressHUD
import Networking

class DiscoverViewController: UIViewController {
    var users = [User]()
    @IBOutlet weak var usersTableVIew: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTableVIew.delegate = self
        usersTableVIew.dataSource = self
        getAllUsers(refreshing: false, refreshControl: nil)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        self.usersTableVIew.insertSubview(refreshControl, at: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func refreshControlAction(refreshControl: UIRefreshControl) {
        getAllUsers(refreshing: true, refreshControl: refreshControl)
    }
    
    func getAllUsers(refreshing: Bool, refreshControl: UIRefreshControl?) {
        let ref = Database.database().reference(withPath: "users")
        SVProgressHUD.showProgress(0, status: "loading")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
                if self.users.count == Int(snapshot.childrenCount) {
                    if refreshing {
                        refreshControl?.endRefreshing()
                    }
                    SVProgressHUD.dismiss()
                    return
                }
                self.users = []
                for item in dict {
                    let uid = String(describing: item.key)
                    if uid == CurrentUser.uid {
                        continue
                    }
                    let json = JSON(item.value)
                    let username = json["username"].stringValue
                    let profilePictureURL = json["profileImageURL"].stringValue
                    let isFollowingCurrentUser = CurrentUser.following.keys.contains(uid)
                    let followersDictionary = json["followers"].rawValue as? NSDictionary
                    let followingDictionary = json["following"].rawValue as? NSDictionary
                    let newUser = User(uid: uid, profilePictureURL: profilePictureURL, profileName: username, followers: followersDictionary as! [String : Bool] , following: followingDictionary as! [String : Bool], isFollowingCurrentUser: isFollowingCurrentUser)
                    self.users.append(newUser)
                }
                self.usersTableVIew.reloadData()
            }
            if refreshing {
                refreshControl?.endRefreshing()
            }
            SVProgressHUD.dismiss()
        })
    }
}

extension DiscoverViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return users.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = usersTableVIew.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? DiscoverUserTableViewCell {
            let user = users[indexPath.row]
            cell.usernameLabel.text = user.profileName
            cell.profileImageView.image = nil
            let networking = Networking(baseURL: user.profilePictureURL, configurationType: .ephemeral)
            networking.downloadImage("") { result in
                switch result {
                case .success(let response):
                    self.users[indexPath.row].profilePicture = response.image
                    cell.profileImageView.image = response.image
                case .failure:
                    cell.profileImageView.image = UIImage(named: "placeholder_camera")
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "profileInfoSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileInfoSegue" {
            let selectedRowIndex = self.usersTableVIew.indexPathForSelectedRow!.row
            let navigationController = segue.destination as! UINavigationController
            let profileVC = navigationController.viewControllers.first as? UserProfileViewController
            profileVC?.user = users[selectedRowIndex]
        }
    }
    
}
