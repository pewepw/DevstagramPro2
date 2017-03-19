//
//  CommentViewController.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 19/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD

class CommentViewController: UIViewController {
    

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.setTitleColor(UIColor.lightGray, for: .normal)
        sendButton.isEnabled = false
        
        handleTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    @IBAction func sendButton(_ sender: Any) {
        
        let ref = FIRDatabase.database().reference()
        let commentsReference = ref.child("comments")
        let newCommentId = commentsReference.childByAutoId().key
        let newCommentsReference = commentsReference.child(newCommentId)
        
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return
        }
        
        let currentUserId = currentUser.uid
        newCommentsReference.setValue(["uid": currentUserId, "commentText": commentTextField.text!]) { (error, ref) in
            if error != nil {
                
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
                return
                
            }
            
            self.empty()
           
        }
        
    }
    
    func empty() {
        self.commentTextField.text = ""
        self.sendButton.isEnabled = false
        self.sendButton.setTitleColor(UIColor.lightGray, for: .normal)
    }
    
    func handleTextField() {
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
    }

    
    func textFieldDidChange() {
        if let commentText = commentTextField.text, !commentText.isEmpty {
            sendButton.setTitleColor(UIColor.black , for: .normal)
            sendButton.isEnabled = true
            
            return
        }
        
        
        sendButton.setTitleColor(UIColor.lightGray , for: .normal)
        sendButton.isEnabled = false
    }

    
}
