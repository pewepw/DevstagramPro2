//
//  HomeTableViewCell.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 15/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    var homeVC: HomeViewController?
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    var user: User? {
        didSet {
            setupUserInfo()
        }
    }
    
    func updateView() {
        
        captionLabel.text = post?.caption
        
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
        }
        
        if let currentUser = FIRAuth.auth()?.currentUser {
            Api.User.REF_USERS.child(currentUser.uid).child("likes").child(post!.id!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? NSNull {
                    self.likeImageView.image = UIImage(named: "like")
                } else {
                    self.likeImageView.image = UIImage(named: "likeSelected")
                }
            })
        }

    }
    
    func setupUserInfo() {
        
        nameLabel.text = user?.username
        
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "ava"))
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        captionLabel.text = ""
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(HomeTableViewCell.commentImageView_TouchUpInside))
        commentImageView.addGestureRecognizer(tapGesture)
        commentImageView.isUserInteractionEnabled = true
        
        let tapGestureForLikeImageView = UITapGestureRecognizer(target: self, action: #selector(HomeTableViewCell.likeImageView_TouchUpInside))
        likeImageView.addGestureRecognizer(tapGestureForLikeImageView)
        likeImageView.isUserInteractionEnabled = true

        
       
        
    }
    
    func commentImageView_TouchUpInside() {
        if let id = post?.id {
            homeVC?.performSegue(withIdentifier: "CommentSegue", sender: id)
        }
        
    }
    
    func likeImageView_TouchUpInside() {
//        if let currentUser = FIRAuth.auth()?.currentUser {
//            Api.User.REF_USERS.child(currentUser.uid).child("likes").child(post!.id!).setValue(true)
//        }
        
        if let currentUser = FIRAuth.auth()?.currentUser {
            Api.User.REF_USERS.child(currentUser.uid).child("likes").child(post!.id!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? NSNull { //never like before then
                    Api.User.REF_USERS.child(currentUser.uid).child("likes").child(self.post!.id!).setValue(true) //should set value to true
                    self.likeImageView.image = UIImage(named: "likeSelected") //should set view should be "likeSelected"
                } else {
                    Api.User.REF_USERS.child(currentUser.uid).child("likes").child(self.post!.id!).removeValue()
                    self.likeImageView.image = UIImage(named: "like")
                }
            })
        }
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "ava")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
