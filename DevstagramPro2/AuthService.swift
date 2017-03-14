//
//  AuthService.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 14/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthService {
    
    //static var shared = AuthService()
    
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void , onError: @escaping (_ errorMessage: String?) -> Void) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            
            onSuccess()
            
        })
    }
    
    
    static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void , onError: @escaping (_ errorMessage: String?) -> Void) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            
            let uid = user?.uid
            let storageRef = FIRStorage.storage().reference().child("profile_image").child(uid!)
            
            storageRef.put(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                
                let profileImageUrl = metadata?.downloadURL()?.absoluteString
                
                self.setUserInfomation(profileImageUrl: profileImageUrl!, username: username, email: email, uid: uid!, onSuccess: onSuccess)
            })
            
            
            
        })
    }
    
    static func setUserInfomation(profileImageUrl: String, username: String, email: String, uid:String, onSuccess: @escaping () -> Void) {
        
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users")
        let newUserReference = usersReference.child(uid)
        newUserReference.setValue(["username": username, "email": email, "profileImageUrl": profileImageUrl])
        onSuccess()
    }
    
}
