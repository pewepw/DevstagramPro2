//
//  CommentApi.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 21/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CommentApi {
    
    var REF_COMMENTS = FIRDatabase.database().reference().child("comments")
    
    func observeComment(withPostId id: String, completion: @escaping (Comment) -> Void) {
        REF_COMMENTS.child(id).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newComment = Comment.transformComment(dict: dict)
                completion(newComment)
            }
            
        })
    }
    
}
