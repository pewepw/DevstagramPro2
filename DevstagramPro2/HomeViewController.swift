//
//  HomeViewController.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 13/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 510
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = self
        loadPosts()
        
     
    }
    
    // after fetch user to array completed, append posts to posts array
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict)
                self.users.append(user)
                completed()
            }
            
        })
        
    }
    
    func loadPosts() {
        FIRDatabase.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPostPhoto(dict: dict)
                
                self.fetchUser(uid: newPost.uid!, completed: {
                    self.posts.append(newPost)
                    self.tableView.reloadData()
                })
                
            }
        })
        
    }
    
    
    
    @IBAction func logout_TouchUpInside(_ sender: Any) {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let SignInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(SignInVC, animated: true, completion: nil)
        
    }
    
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        
        cell.post = post
        cell.user = user
        
        return cell
    }
    
}
