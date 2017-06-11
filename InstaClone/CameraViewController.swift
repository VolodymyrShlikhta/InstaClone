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

class CameraViewController: UIViewController {

    @IBOutlet weak var removeBarButton: UIBarButtonItem!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        let postImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPostPhoto))
        postImageView.addGestureRecognizer(postImageTapGesture)
        postImageView.isUserInteractionEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        handlePost()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func removeBarButtonClicked(_ sender: Any) {
        cleanFields()
        handlePost()
    }
    
    @IBAction func postButtonClicked(_ sender: UIButton) {
        view.endEditing(true)
        SVProgressHUD.show(withStatus: "Posting...")
        if let postImage = self.selectedImage, let imageData = UIImageJPEGRepresentation(postImage, 0.1) {
            let photoUID = NSUUID().uuidString
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("posts").child(photoUID)
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: "\(error!.localizedDescription)")
                    return
                }
                let photoURL = metadata?.downloadURL()?.absoluteString
                self.sendDataToDatabase(photoURL : photoURL!)
            
            })
        } else {
            SVProgressHUD.showError(withStatus: "Something went wrong!")
        }
    }
    
    func handlePost() {
        if selectedImage != nil {
            removeBarButton.isEnabled = true
            postButton.isEnabled = true
            postButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func sendDataToDatabase(photoURL : String)
    {
        let databaseRef = Database.database().reference()
        let postsReference = databaseRef.child("posts")
        let newPostId = postsReference.childByAutoId().key
        let newPostReference = postsReference.child(newPostId)
        newPostReference.setValue(["photoURL" : photoURL, "caption" : postTextView.text!], withCompletionBlock: {
            (error, ref) in
            if error != nil {
                SVProgressHUD.showError(withStatus: "\(error!.localizedDescription)")
                return
            }
            SVProgressHUD.showSuccess(withStatus: "Success")
            self.cleanFields()
            self.tabBarController?.selectedIndex = 0
        })
        
    }
    
    func cleanFields(){
        self.postTextView.text = ""
        self.postImageView.image = UIImage(named: "placeholder_camera")
        self.selectedImage = nil
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let newPostImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = newPostImage
            postImageView.image = newPostImage
        }
        dismiss(animated: true, completion:  nil)
    }
}
