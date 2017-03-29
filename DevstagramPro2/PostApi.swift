//
//  PostApi.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 21/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostApi {
    
    var REF_POST = FIRDatabase.database().reference().child("posts")
    
    func observePosts(completion: @escaping (Post) -> Void) {
        REF_POST.observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPostPhoto(dict: dict, key: snapshot.key)
                completion(newPost)
            }
            
        })
        
    }
    
    func observePost(withId id:String, completion: @escaping (Post) -> Void) {
        REF_POST.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let post = Post.transformPostPhoto(dict: dict, key: snapshot.key)
                completion(post)
            }
            
        })
    }
    
    func observeLikeCount(withPostId id: String, completion: @escaping (Int) -> Void) {
        REF_POST.child(id).observe(.childChanged, with: { (snapshot) in
            if let value = snapshot.value as? Int {
                completion(value)
            }
            
        })
    }
    
    func observeTopPosts(completion: @escaping (Post) -> Void) {
        REF_POST.queryOrdered(byChild: "likeCount").observeSingleEvent(of: .value, with: { (snapshot) in
            let arraySnapshot = (snapshot.children.allObjects as! [FIRDataSnapshot]).reversed()
            
            //another way of for loop
//            arraySnapshot.forEach({ (child) in
//                if let dict = child.value as? [String: Any] {
//                    let post = Post.transformPostPhoto(dict: dict, key: snapshot.key)
//                    completion(post)
//                }
//            })
            for child in arraySnapshot {
                if let dict = child.value as? [String: Any] {
                    let post = Post.transformPostPhoto(dict: dict, key: snapshot.key)
                    completion(post)
                }

            }
        })
    }
    
    func incrementLikes(postId: String, onSuccess: @escaping (Post) -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        let postRef = Api.Post.REF_POST.child(postId)
        postRef.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Api.User.CURRENT_USER?.uid {
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    // Unstar the post and remove self from stars
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    // Star the post and add self to stars
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return FIRTransactionResult.success(withValue: currentData)
            }
            return FIRTransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                onError(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String: Any] {
                let post = Post.transformPostPhoto(dict: dict, key: snapshot!.key)
                onSuccess(post)
            }
        }

    }
    
    
}
