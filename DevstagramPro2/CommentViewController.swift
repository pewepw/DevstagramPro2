//
//  CommentViewController.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 19/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import UIKit
//import FirebaseDatabase
//import FirebaseAuth
import SVProgressHUD

class CommentViewController: UIViewController {
    
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintToBottom: NSLayoutConstraint!
    
    var postId: String!
    var comments = [Comment]()
    var users = [User]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Comment"
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        sendButton.setTitleColor(UIColor.lightGray, for: .normal)
        sendButton.isEnabled = false
        
        empty()
        handleTextField()
        loadComments()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        //print(keyboardFrame)
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = keyboardFrame!.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func loadComments() {
        
        Api.Post_Comment.REF_POST_COMMENTS.child(self.postId).observe(.childAdded, with: { (snapshot) in
            //print("**********")
            //print(snapshot.key)
            
            Api.Comment.observeComment(withPostId: snapshot.key, completion: { (comment) in
                self.fetchUser(uid: comment.uid!, completed: {
                    self.comments.append(comment)
                    self.tableView.reloadData()
                })
            })
            
        })
    }
    
    //            FIRDatabase.database().reference().child("comments").child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshotComment) in
    //                if let dict = snapshotComment.value as? [String: Any] {
    //                    let newComment = Comment.transformComment(dict: dict)
    //
    //                    self.fetchUser(uid: newComment.uid!, completed: {
    //                        self.comments.append(newComment)
    //                        self.tableView.reloadData()
    //                    })
    //
    //                }
    //
    //            })
    
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        Api.User.observeUser(withId: uid) { (user) in
            self.users.append(user)
            completed()
        }
    }
    //        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
    //            if let dict = snapshot.value as? [String: Any] {
    //                let user = User.transformUser(dict: dict)
    //                self.users.append(user)
    //                completed()
    //            }
    //
    //        })
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func sendButton(_ sender: Any) {
        
//        let ref = FIRDatabase.database().reference()
//        let commentsReference = ref.child("comments")
        let commentsReference = Api.Comment.REF_COMMENTS
        let newCommentId = commentsReference.childByAutoId().key
        let newCommentsReference = commentsReference.child(newCommentId)
        
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        
        let currentUserId = currentUser.uid
        newCommentsReference.setValue(["uid": currentUserId, "commentText": commentTextField.text!]) { (error, ref) in
            if error != nil {
                
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
                return
                
            }
            
//            let postCommentRef = FIRDatabase.database().reference().child("post-comments").child(self.postId).child(newCommentId)
            let postCommentRef = Api.Post_Comment.REF_POST_COMMENTS.child(self.postId).child(newCommentId)
            postCommentRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    return
                }
            })
            
            self.empty()
            self.view.endEditing(true)
            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Comment_ProfileSegue" {
            let profileVC = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            profileVC.userId = userId
        }
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
        cell.delegate = self
        
        return cell
    }
    
}

extension CommentViewController: CommentTableViewCellDelegate {
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Comment_ProfileSegue", sender: userId)
    }
}
