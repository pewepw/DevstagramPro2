//
//  UserApi.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 21/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserApi {
    
    var REF_USERS = FIRDatabase.database().reference().child("users")
    
    func observeUser(withId uid: String, completion: @escaping (User) -> Void) {
        REF_USERS.child(uid).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func observeCurrentUser(completion: @escaping (User) -> Void) {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return
        }
        REF_USERS.child(currentUser.uid).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func observeUsers(completion: @escaping (User) -> Void) {
        REF_USERS.observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                //do not include current user in people view
                if user.id! != Api.User.CURRENT_USER?.uid {
                    completion(user)
                }
            }
        })
    }
    
    func queryUser(withText text: String, completion: @escaping (User) -> Void) {
        REF_USERS.queryOrdered(byChild: "username_lowercase").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: { (snapshot) in
            snapshot.children.forEach({ (s) in
                let child = s as! FIRDataSnapshot
                if let dict = child.value as? [String: Any] {
                    let user = User.transformUser(dict: dict, key: child.key)
                    completion(user)
                }
            })
        })
    }
    
    var CURRENT_USER: FIRUser? {
        if let currentUser = FIRAuth.auth()?.currentUser {
            return currentUser
        }
        
        return nil
    }
    
    var REF_CURRENT_USER: FIRDatabaseReference? {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return nil
        }
        
        return REF_USERS.child(currentUser.uid)
    }
    
}
