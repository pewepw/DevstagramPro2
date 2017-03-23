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
}
