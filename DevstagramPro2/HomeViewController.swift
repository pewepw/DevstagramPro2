//
//  HomeViewController.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 13/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import UIKit
//import FirebaseAuth
//import FirebaseDatabase
import SVProgressHUD
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var posts = [Post]()
    var users = [User]()
    
    
    let logoImage = UIImageView()
    let subview = UIView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.estimatedRowHeight = 510
        tableView.rowHeight = UITableViewAutomaticDimension
        

        
        subview.backgroundColor = UIColor.black
        subview.frame.size.width = UIScreen.main.bounds.width
        subview.frame.size.height = UIScreen.main.bounds.height
        view.addSubview(subview)
        
        logoImage.frame = CGRect(x: (view.bounds.size.width / 2) - 90 , y: (view.bounds.size.height / 2) - 90, width: 180, height: 180)
        logoImage.image = UIImage(named: "D")
        view.addSubview(logoImage)
        
        animatingLogo()
        
        loadPosts()
        
        
    }
    
    func animatingLogo() {
        tabBarController?.tabBar.alpha = 0
        navigationController?.navigationBar.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            self.logoImage.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }) { (finished: Bool) in
            if finished {
                
                UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
                    self.logoImage.transform = CGAffineTransform(scaleX: 20, y: 20)
                }, completion: { (finished) in
                    if finished {
                        
                        
                        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                            self.logoImage.alpha = 0
                            self.subview.alpha = 0
                            self.tabBarController?.tabBar.alpha = 1
                            self.navigationController?.navigationBar.alpha = 1
                        }, completion: nil)
                    }
                })
                
            }
        }
    }
    
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        Api.User.observeUser(withId: uid) { (user) in
            self.users.append(user)
            completed()
        }
    }
    
    //    // after fetch user to array completed, append posts to posts array
    //    func fetchUser(uid: String, completed: @escaping () -> Void) {
    //        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
    //            if let dict = snapshot.value as? [String: Any] {
    //                let user = User.transformUser(dict: dict)
    //                self.users.append(user)
    //                completed()
    //            }
    //
    //        })
    //
    //    }
    
    func loadPosts() {
        
        if posts.count >= 1 {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.isHidden = true
        }
        
        Api.Feed.observeFeed(withUserId: Api.User.CURRENT_USER!.uid) { (post) in
            guard let postId = post.uid else {
                return
            }
            self.fetchUser(uid: postId, completed: { 
                self.posts.append(post)
                
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
                
                self.tableView.reloadData()
            })
        }
        
        Api.Feed.observeFeedRemoved(withId: Api.User.CURRENT_USER!.uid) { (post) in
//            for (index, post) in self.posts.enumerated() {
//                if post.id == key {
//                    self.posts.remove(at: index)
//                }
//            }
            
            self.posts = self.posts.filter { $0.id != post.id }
            self.users = self.users.filter { $0.id != post.uid }
            
            self.tableView.reloadData()
        }
        
    }
    
//    func loadPosts() {
//
//        activityIndicatorView.startAnimating()
//
//        Api.Post.observePosts { (post) in
//            self.fetchUser(uid: post.uid!, completed: {
//                self.posts.append(post)
//
//                self.activityIndicatorView.stopAnimating()
//                self.activityIndicatorView.isHidden = true
//
//                self.tableView.reloadData()
//            })
//        }
        
        //        FIRDatabase.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
        //            if let dict = snapshot.value as? [String: Any] {
        //                let newPost = Post.transformPostPhoto(dict: dict, key: snapshot.key)
        //
        //                self.fetchUser(uid: newPost.uid!, completed: {
        //                    self.posts.append(newPost)
        //
        //                    self.activityIndicatorView.stopAnimating()
        //                    self.activityIndicatorView.isHidden = true
        //
        //                    self.tableView.reloadData()
        //                })
        //
        //            }
        //        })
        //  }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //        self.tabBarController?.tabBar.isHidden = false
    //
    //    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentSegue" {
            let commentVC = segue.destination as! CommentViewController
            let postId = sender as! String
            commentVC.postId = postId
        }
        
        if segue.identifier == "Home_ProfileSegue" {
            let profileVC = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            profileVC.userId = userId
        }
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
        //cell.homeVC = self
        cell.delegate = self
        
        return cell
    }
    
}

extension HomeViewController: HomeTableViewCellDelegate {
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "CommentSegue", sender: postId)
    }
    
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Home_ProfileSegue", sender: userId)
    }
}
