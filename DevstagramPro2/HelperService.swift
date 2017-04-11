//
//  HelperService.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 25/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import Foundation
import FirebaseStorage
import SVProgressHUD

class HelperService {
    
    static func uploadDataToServer(data: Data, videoUrl: URL? = nil, caption: String, ratio: CGFloat, onSuccess: @escaping () -> Void) {
        if let videoUrl = videoUrl {
            self.uploadVideoToFirebaseStorage(videoUrl: videoUrl, onSuccess: { (videoUrl) in
                uploadImageToFirebaseStorage(data: data, onSuccess: { (thumbnailImageUrl) in
                    sendDataToDatabase(photoUrl: thumbnailImageUrl, videoUrl: videoUrl, caption: caption, ratio: ratio, onSuccess: onSuccess)
                })
            })
        } else {
            uploadImageToFirebaseStorage(data: data) { (photoUrl) in
                self.sendDataToDatabase(photoUrl: photoUrl, caption: caption, ratio: ratio, onSuccess: onSuccess)
            }
        }
    }
    
    static func uploadVideoToFirebaseStorage(videoUrl: URL, onSuccess: @escaping(_ videoUrl: String) -> Void) {
        let videoIdString = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("posts").child(videoIdString)
        storageRef.putFile(videoUrl, metadata: nil) { (metadata, error) in
            if error != nil {
                
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
                
                return
            }
            
            if let videoUrl = metadata?.downloadURL()?.absoluteString {
                onSuccess(videoUrl)
            }
        }
    }
    
    static func uploadImageToFirebaseStorage(data: Data, onSuccess: @escaping(_ imageUrl: String) -> Void) {
        let photoIdString = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("posts").child(photoIdString)
        storageRef.put(data, metadata: nil) { (metadata, error) in
            if error != nil {
                
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
                
                return
            }
            
            if let photoUrl = metadata?.downloadURL()?.absoluteString {
                onSuccess(photoUrl)
            }
        }
    }
    
    static func sendDataToDatabase(photoUrl: String, videoUrl: String? = nil, caption: String, ratio: CGFloat, onSuccess: @escaping () -> Void) {
        let newPostId = Api.Post.REF_POST.childByAutoId().key
        let newPostReference = Api.Post.REF_POST.child(newPostId)
        
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        
        let currentUserId = currentUser.uid
        
        var dict = ["uid": currentUserId, "photoUrl": photoUrl, "caption": caption, "likeCount": 0, "ratio": ratio] as [String : Any]
        if let videoUrl = videoUrl {
            dict["videoUrl"] = videoUrl
        }
        
        newPostReference.setValue(dict) { (error, ref) in
            if error != nil {
                
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
                return
            }
            
            Api.Feed.REF_FEED.child(Api.User.CURRENT_USER!.uid).child(newPostId).setValue(true)
            
            let myPostRef = Api.MyPosts.REF_MYPOSTS.child(currentUserId).child(newPostId)
            myPostRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    return
                }
            })
            
            SVProgressHUD.showSuccess(withStatus: "Success")
            onSuccess()
        }
    }
    
}
