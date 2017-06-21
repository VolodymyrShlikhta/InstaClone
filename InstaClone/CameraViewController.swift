//
//  CameraViewController.swift
//  InstaClone
//
//  Created by Relorie on 6/5/17.
//  Copyright © 2017 Relorie. All rights reserved.
//

import UIKit
import FirebaseStorage
import SVProgressHUD
import FirebaseDatabase
import FirebaseAuth

class CameraViewController: UIViewController {
    @IBOutlet weak var removeBarButton: UIBarButtonItem!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    
    private var databaseRef = Database.database().reference()
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleImageViewTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        handlePost()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func removeBarButtonClicked(_ sender: Any) {
        cleanFields()
        handlePost()
        Utilities.setNewCurrentUserInfo()
    }
    
    @IBAction func postButtonClicked(_ sender: UIButton) {
        view.endEditing(true)
        SVProgressHUD.show(withStatus: "Posting...")
        if let postImage = self.selectedImage, let imageData = UIImageJPEGRepresentation(postImage, 0.1), let caption = postTextView.text {
            guard let uid = Auth.auth().currentUser?.uid else {
                print("User error")
                return
            }
            sendDataToFirebase(imageData: imageData, forUserId: uid, caption: caption)
        } else {
            SVProgressHUD.showError(withStatus: "Something went wrong!")
        }
    }
    
    func handleImageViewTapGesture() {
        let postImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPostPhoto))
        postImageView.addGestureRecognizer(postImageTapGesture)
        postImageView.isUserInteractionEnabled = true
    }
    
    func handlePost() {
        if selectedImage != nil {
            removeBarButton.isEnabled = true
            postButton.isEnabled = true
            postButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            postButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
        } else {
            postButton.isEnabled = false
            removeBarButton.isEnabled = false
            postButton.backgroundColor = UIColor.lightGray
        }
    }
    
    func handleSelectPostPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    func sendDataToFirebase(imageData: Data, forUserId uid: String, caption: String) {
        let imageName = NSUUID().uuidString
        let photosRef = Storage.storage().reference().child("posts")
        let photoRef = photosRef.child("\(uid)")
        
        photoRef.child("\(imageName)").putData(imageData, metadata: nil, completion: { (metadata, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: "\(error!.localizedDescription)")
                return
            }
            if let photoURL = metadata?.downloadURL()?.absoluteString {
                self.sendDataToDatabase(uid: uid, caption: caption, photoURL: photoURL)
            }
        })
    }
    
    func sendDataToDatabase(uid : String, caption : String, photoURL: String) {
        let values: Dictionary<String, Any> = ["uid": uid, "caption": caption, "photoURL": photoURL, "timestamp": ServerValue.timestamp()]
        let postPath = databaseRef.child("posts").childByAutoId()
        
        postPath.setValue(values) { (error, ref) -> Void in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
                return
            } else {
                self.updateNumberOfPosts(forUID: uid)
                SVProgressHUD.showSuccess(withStatus: "Post added!")
                self.cleanFields()
            }
        }
    }
    
    func updateNumberOfPosts(forUID uid: String) {
        databaseRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let postCount = value?["postCount"] as? Int ?? 0
            let newCount = postCount + 1
            self.databaseRef.child("users").child(uid).updateChildValues(["postCount": newCount])
        }) { (error) in
           SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    func cleanFields() {
        self.postTextView.text = ""
        self.postImageView.image = UIImage(named: "placeholder_camera")
        self.selectedImage = nil
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let newPostImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = newPostImage
            postImageView.image = newPostImage
        }
        dismiss(animated: true, completion:  nil)
    }
}
