//
//  HeaderProfileCollectionReusableView.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 23/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import UIKit

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myPostCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingsCountLabel: UILabel!
    
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
        }
        
}


