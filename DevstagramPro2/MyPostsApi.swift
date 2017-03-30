//
//  MyPostsApi.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 23/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MyPostsApi {
    
    var REF_MYPOSTS = FIRDatabase.database().reference().child("myPosts")
    
    func fetchMyPosts(userId: String, completion: @escaping (String) -> Void) {
        REF_MYPOSTS.child(userId).observe(.childAdded, with: { (snapshot) in
            completion(snapshot.key)
        })
        
    }
    
    func fetchCountMyPosts(userId: String, completion: @escaping (Int) -> Void) {
        REF_MYPOSTS.child(userId).observe(.value, with: { (snapshot) in
            let count = Int(snapshot.childrenCount)
            completion(count)
        })
    }
    
    
}
