//
//  HeaderProfileCollectionReusableView.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 23/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import UIKit
protocol HeaderProfileCollectionReusableViewDelegate {
    func updateFollowButton(forUser user: User)
}

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myPostCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingsCountLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var delegate: HeaderProfileCollectionReusableViewDelegate?
    
    var user: User? {
        didSet {
            updateView()
        }
    }
    //    func updateView() {
    //        guard let currentUser = FIRAuth.auth()?.currentUser else {
    //           return
    //        }
    //        Api.User.observeUser(withId: currentUser.uid) { (user) in
    //            self.nameLabel.text = user.username
    //            if let photoUrlString = user.profileImageUrl {
    //                let photoUrl = URL(string: photoUrlString)
    //                self.profileImage.sd_setImage(with: photoUrl)
    //            }
    //
    //       }
    
    func updateView() {
        self.nameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            self.profileImage.sd_setImage(with: photoUrl)
        }
        
        Api.MyPosts.fetchCountMyPosts(userId: user!.id!) { (count) in
            self.myPostCountLabel.text = "\(count)"
        }
        
        Api.Follow.fetchCountFollowing(userId: user!.id!) { (count) in
            self.followingsCountLabel.text = "\(count)"
        }
        
        Api.Follow.fetchCountFollowers(userId: user!.id!) { (count) in
            self.followersCountLabel.text = "\(count)"
        }
        
        if user?.id == Api.User.CURRENT_USER?.uid {
            followButton.setTitle("Edit Profile", for: .normal)
        } else {
            updateStateFollowButton()
            
        }
    }
    
    func updateStateFollowButton() {
        if user!.isFollowing! == true {
            configureUnFollowButton()
        } else {
            configureFollowButton()
        }
    }
    
    func configureFollowButton() {
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232/255, alpha: 1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        followButton.setTitleColor(UIColor.white, for: .normal)
        followButton.backgroundColor = UIColor(red: 69/255, green: 142/255, blue: 255/255, alpha: 1)
        
        followButton.setTitle("Follow", for: UIControlState.normal)
        followButton.addTarget(self, action: #selector(self.followAction), for: UIControlEvents.touchUpInside)
    }
    
    func configureUnFollowButton() {
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232/255, alpha: 1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        followButton.setTitleColor(UIColor.black, for: .normal)
        followButton.backgroundColor = UIColor.clear
        
        followButton.setTitle("Following", for: UIControlState.normal)
        followButton.addTarget(self, action: #selector(self.unFollowAction), for: UIControlEvents.touchUpInside)
    }
    
    
    
    func followAction() {
        if user!.isFollowing! == false {
            Api.Follow.followAction(withUser: user!.id!)
            configureUnFollowButton()
            user!.isFollowing = true
            delegate?.updateFollowButton(forUser: user!)
        }
        
        
    }
    
    func unFollowAction() {
        if user!.isFollowing! == true {
            Api.Follow.unFollowAction(withUser: user!.id!)
            configureFollowButton()
            user!.isFollowing = false
            delegate?.updateFollowButton(forUser: user!)
        }
        
        
    }
    
}


