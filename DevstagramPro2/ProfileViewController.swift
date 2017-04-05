//
//  ProfileViewController.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 13/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import UIKit
//import FirebaseAuth
//import FirebaseDatabase

class ProfileViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var user: User!
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchUser()
        fetchMyPosts()
        
    }

    func fetchUser() {
        Api.User.observeCurrentUser { (user) in
            self.user = user
            self.navigationItem.title = user.username
            self.collectionView.reloadData()
           
        }
    }
    
    func fetchMyPosts() {
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        Api.MyPosts.REF_MYPOSTS.child(currentUser.uid).observe(.childAdded) { (snapshot) in
            Api.Post.observePost(withId: snapshot.key, completion: { (post) in
                self.posts.append(post)
                self.collectionView.reloadData()
            })
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Profile_SettingSegue" {
            let settingVC = segue.destination as! SettingTableViewController
            settingVC.delegate = self
        }
        
        if segue.identifier == "Profile_DetailSegue" {
            let detailVC = segue.destination as! DetailViewController
            let postId = sender as! String
            detailVC.postId = postId
        }

    }
  

}

extension ProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader , withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as! HeaderProfileCollectionReusableView
        if let user = self.user {
            headerViewCell.user = user
            headerViewCell.delegate2 = self
        }
        
        return headerViewCell
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width/3) - 1, height: (collectionView.frame.size.width/3) - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension ProfileViewController: HeaderProfileCollectionReusableViewDelegateSwitchSettingVC {
    func goToSettingVC() {
        performSegue(withIdentifier: "Profile_SettingSegue", sender: nil)
    }
}

extension ProfileViewController: SettingTableViewControllerDelegate {
    func updateUserInfo() {
        self.fetchUser()
    }
}

extension ProfileViewController: PhotoCollectionViewCellDelegate {
    func goToDetailVC(postId: String) {
        performSegue(withIdentifier: "Profile_DetailSegue", sender: postId)
    }
}
