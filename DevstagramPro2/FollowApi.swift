//
//  FollowApi.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 26/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FollowApi {
    
    var REF_FOLLOWERS = FIRDatabase.database().reference().child("followers")
    var REF_FOLLOWING = FIRDatabase.database().reference().child("following")
    
    func followAction(withUser id: String) {
        REF_FOLLOWERS.child(id).child(Api.User.CURRENT_USER!.uid).setValue(true)
        REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(id).setValue(true)

    }
    
    func unFollowAction(withUser id: String) {
        REF_FOLLOWERS.child(id).child(Api.User.CURRENT_USER!.uid).setValue(NSNull())
        REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(id).setValue(NSNull())
    }
    
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        REF_FOLLOWERS.child(userId).child(Api.User.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                completed(false)
            } else {
                completed(true)
            }
        })
    }
    
}
