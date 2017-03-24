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
    
    static func uploadDataToServer(data: Data, caption: String, onSucess: @escaping () -> Void) {
        
        let photoIdString = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("posts").child(photoIdString)
        storageRef.put(data, metadata: nil) { (metadata, error) in
            if error != nil {
                
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
                
                return
            }
            
            let photoUrl = metadata?.downloadURL()?.absoluteString
            self.sendDataToDatabase(photoUrl: photoUrl!, caption: caption, onSuccess: onSucess)


        }


    }
    
    
    static func sendDataToDatabase(photoUrl: String, caption: String, onSuccess: @escaping () -> Void) {
        let newPostId = Api.Post.REF_POST.childByAutoId().key
        let newPostReference = Api.Post.REF_POST.child(newPostId)
        
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        newPostReference.setValue(["uid": currentUserId, "photoUrl": photoUrl, "caption": caption]) { (error, ref) in
            if error != nil {
                
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
                return
                
            }
            
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
