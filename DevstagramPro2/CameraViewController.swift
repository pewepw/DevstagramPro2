//
//  CameraViewController.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 13/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseStorage
import FirebaseDatabase

class CameraViewController: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handlePost()
    }
    
    
    func handlePost() {
        if selectedImage != nil {
            shareButton.setTitleColor(UIColor.white, for: .normal)
            shareButton.backgroundColor = UIColor.black
            shareButton.isEnabled = true
            removeButton.isEnabled = true
        } else {
            shareButton.backgroundColor = UIColor.lightGray
            shareButton.isEnabled = false
            removeButton.isEnabled = false
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleSelectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareButton_TouchUpInside(_ sender: Any) {
        
        view.endEditing(true)
        SVProgressHUD.show()
        
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            let photoIdString = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("posts").child(photoIdString)
            
            storageRef.put(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)

                    return
                }
                
                let photoUrl = metadata?.downloadURL()?.absoluteString
                self.sendDataToDatabase(photoUrl: photoUrl!)
                
            })
        } else {
            
            SVProgressHUD.showError(withStatus: "Profile image can't be empty")
        }
        
    }
    
    
    
    @IBAction func remove_TouchUpInside(_ sender: Any) {
        clean()
        handlePost()
    }
    
    func sendDataToDatabase(photoUrl: String) {
        let ref = FIRDatabase.database().reference()
        let postsReference = ref.child("posts")
        let newPostId = postsReference.childByAutoId().key
        let newPostsReference = postsReference.child(newPostId)
        newPostsReference.setValue(["photoUrl": photoUrl, "caption": captionTextView.text!]) { (error, ref) in
            if error != nil {
                
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
                return
                
            }
            
            SVProgressHUD.showSuccess(withStatus: "Success")
            self.clean()
            self.tabBarController?.selectedIndex = 0
        }
        
    }
    
    func clean() {
        self.captionTextView.text = ""
        self.photo.image = UIImage(named: "Placeholder-image")
        self.selectedImage = nil

    }
    
}

    extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            
            if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                photo.image = image
                selectedImage = image
            }
            
            dismiss(animated: true, completion: nil)
            
        }
        

}
