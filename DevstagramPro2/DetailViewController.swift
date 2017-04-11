//
//  DetailViewController.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 04/04/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var postId = ""
    var post = Post()
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.estimatedRowHeight = 510
        tableView.rowHeight = UITableViewAutomaticDimension
        
        loadPost()
    }
    
    func loadPost() {
        Api.Post.observePost(withId: postId) { (post) in
            guard let postUid = post.uid else {
                return
            }
            self.fetchUser(uid: postUid, completed: {
                self.post = post
                self.tableView.reloadData()
            })
        }
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        Api.User.observeUser(withId: uid) { (user) in
            self.user = user
            completed()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail_CommentSegue" {
            let commentVC = segue.destination as! CommentViewController
            let postId = sender as! String
            commentVC.postId = postId
        }
        
        if segue.identifier == "Detail_ProfileUserSegue" {
            let profileVC = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            profileVC.userId = userId
        }
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        
        cell.post = post
        cell.user = user
        cell.delegate = self
        
        return cell
    }
    
}

extension DetailViewController: HomeTableViewCellDelegate {
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "Detail_CommentSegue", sender: postId)
    }
    
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Detail_ProfileUserSegue", sender: userId)
    }
    
}
