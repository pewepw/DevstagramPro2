//
//  Post.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 15/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import UIKit
import FirebaseAuth

class Post {
    
    var caption: String?
    var photoUrl: String?
    var uid: String?
    var id: String?
    var likeCount: Int?
    var likes: Dictionary<String, Any>?
    var isLiked: Bool?
    var videoUrl: String?
    var ratio: CGFloat?
    
}

extension Post {
    
    static func transformPostPhoto(dict: [String: Any], key: String) -> Post {
        let post = Post()
        
        post.id = key
        post.caption = dict["caption"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        post.videoUrl = dict["videoUrl"] as? String
        post.uid = dict["uid"] as? String
        post.likeCount = dict["likeCount"] as? Int
        post.likes = dict["likes"] as? Dictionary<String, Any>
        post.ratio = dict["ratio"] as? CGFloat
        if let currentUserId = FIRAuth.auth()?.currentUser?.uid {
            if post.likes != nil {
                if post.likes?[currentUserId] != nil {
                    post.isLiked = true
                } else {
                    post.isLiked = false
                }
            }
        }
        
        
        return post
    }
    
    static func transformPostVideo() {
        
    }
    
}
