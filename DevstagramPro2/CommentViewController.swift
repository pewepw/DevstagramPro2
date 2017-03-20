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
    @IBOutlet weak var tableView: UITableView!
    
    let postId = "-KfHtdSpw7UyLDAiju1d"
    var comments = [Comment]()
    var users = [User]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        sendButton.setTitleColor(UIColor.lightGray, for: .normal)
        sendButton.isEnabled = false
        
        empty()
        handleTextField()
        loadComments()
        
    }
    
    func loadComments() {
        let postCommentRef = FIRDatabase.database().reference().child("post-comments").child(self.postId)
        postCommentRef.observe(.childAdded, with: { (snapshot) in
            print("**********")
            print(snapshot.key)
            FIRDatabase.database().reference().child("comments").child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshotComment) in
                if let dict = snapshotComment.value as? [String: Any] {
                    let newComment = Comment.transformComment(dict: dict)
                    
                    self.fetchUser(uid: newComment.uid!, completed: {
                        self.comments.append(newComment)
                        self.tableView.reloadData()
                    })
                    
                }

            })
        })
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict)
                self.users.append(user)
                completed()
            }
            
        })
        
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
            
            let postCommentRef = FIRDatabase.database().reference().child("post-comments").child(self.postId).child(newCommentId)
            postCommentRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    return
                }
            })
            
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

extension CommentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
        
        cell.comment = comment
        cell.user = user
        
        return cell
    }
    
}
