//
//  FeedApi.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 29/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FeedApi {
    var REF_FEED = FIRDatabase.database().reference().child("feed")
    
    func observeFeed(withUserId id: String, completion: @escaping (Post) ->Void) {
        REF_FEED.child(id).observe(.childAdded, with: { snapshot in
            let key = snapshot.key
            Api.Post.observePost(withId: key, completion: { (post) in
                completion(post)
            })
        })
        
    }
    
    func observeFeedRemoved(withId id: String, completion: @escaping (Post) ->Void) {
        REF_FEED.child(id).observe(.childRemoved, with: { (snapshot) in
            let key = snapshot.key
            Api.Post.observePost(withId: key, completion: { (post) in
                completion(post)
            })
            
        })
    }

}
