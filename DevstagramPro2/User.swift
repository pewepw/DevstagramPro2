//
//  User.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 16/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import Foundation

class User {
    var email: String?
    var profileImageUrl: String?
    var username: String?
}

extension User {
    static func transformUser(dict: [String: Any]) -> User {
        let user = User()
        
        user.profileImageUrl = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        user.username = dict["username"] as? String
        
        return user
    }
}
