//
//  CameraViewController.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 13/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD
//import FirebaseStorage
//import FirebaseDatabase
import FirebaseAuth

class CameraViewController: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    
    var selectedImage: UIImage?
    var videoUrl: URL?
    
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
        pickerController.mediaTypes = ["public.image", "public.movie"]
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareButton_TouchUpInside(_ sender: Any) {
        
        view.endEditing(true)
        SVProgressHUD.show()
        
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            let ratio = profileImg.size.width / profileImg.size.height
            HelperService.uploadDataToServer(data: imageData, videoUrl: self.videoUrl, caption: captionTextView.text!, ratio: ratio, onSuccess: {
                self.clean()
                self.tabBarController?.selectedIndex = 0
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
        //        let ref = FIRDatabase.database().reference()
        //        let postsReference = ref.child("posts")
        //        let newPostId = postsReference.childByAutoId().key
        //        let newPostsReference = postsReference.child(newPostId)
        //
        //        guard let currentUser = FIRAuth.auth()?.currentUser else {
        //            return
        //        }
        //
        //        let currentUserId = currentUser.uid
        //        newPostsReference.setValue(["uid": currentUserId, "photoUrl": photoUrl, "caption": captionTextView.text!]) { (error, ref) in
        //           if error != nil {
        //
        //                SVProgressHUD.showError(withStatus: error!.localizedDescription)
        //                return
        //
        //            }
        //
        //            let myPostRef = Api.MyPosts.REF_MYPOSTS.child(currentUserId).child(newPostId)
        //            myPostRef.setValue(true, withCompletionBlock: { (error, ref) in
        //                if error != nil {
        //                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
        //                    return
        //                }
        //            })
        //
        //
        //            SVProgressHUD.showSuccess(withStatus: "Success")
        //            self.clean()
        //           self.tabBarController?.selectedIndex = 0
        //        }
        
    }
    
    func clean() {
        self.captionTextView.text = ""
        self.photo.image = UIImage(named: "Placeholder-image")
        self.selectedImage = nil
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Filter_Segue" {
            let filterVC = segue.destination as! FilterViewController
            filterVC.selectedImage = self.selectedImage
            filterVC.delegate = self
        }
    }
    
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let videoUrl = info["UIImagePickerControllerMediaURL"] as? URL {
            if let thumbnailImage = self.thumbnailImageForFileUrl(videoUrl) {
                selectedImage = thumbnailImage
                photo.image = thumbnailImage
                self.videoUrl = videoUrl
            }
            dismiss(animated: true, completion: nil)
        }
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            photo.image = image
            selectedImage = image
            dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "Filter_Segue", sender: nil)
            })
        }
        
    }
    
    func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(10, 1), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let err {
            print(err)
        }
        
        return nil
    }
    
}

extension CameraViewController: FilterViewControllerDelegate {
    func updatePhoto(image: UIImage) {
        self.photo.image = image
    }
}
