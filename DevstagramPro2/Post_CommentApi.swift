//
//  Post_CommentApi.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 21/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Post_CommentApi {
    
    var REF_POST_COMMENTS = FIRDatabase.database().reference().child("post-comments")

}
