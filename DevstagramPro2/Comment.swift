//
//  Comment.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 20/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import Foundation

class Comment {
    
    var commentText: String?
    var uid: String?
    
}

extension Comment {
    
    static func transformComment(dict: [String: Any]) -> Comment {
        let comment = Comment()
        
        comment.commentText = dict["commentText"] as? String
        comment.uid = dict["uid"] as? String
        
        return comment
    }
    
}
