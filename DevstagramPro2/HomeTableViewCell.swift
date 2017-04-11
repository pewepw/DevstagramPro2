//
//  HomeTableViewCell.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 15/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD
protocol HomeTableViewCellDelegate {
    func goToCommentVC(postId: String)
    func goToProfileUserVC(userId: String)
}

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var volumeView: UIView!
    @IBOutlet weak var volumeButton: UIButton!
    @IBOutlet weak var heightConstraintPhoto: NSLayoutConstraint!
    
    var delegate: HomeTableViewCellDelegate?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
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
    
    var isMuted = true
    
    func updateView() {
        
        captionLabel.text = post?.caption
        
        if let ratio = post?.ratio {
            heightConstraintPhoto.constant = UIScreen.main.bounds.width / ratio
            layoutIfNeeded()
        }
        
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
        }
        
        if let videoUrlString = post?.videoUrl, let videoUrl = URL(string: videoUrlString) {
            
            self.volumeView.isHidden = false
            player = AVPlayer(url: videoUrl)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = postImageView.frame
            playerLayer?.frame.size.width = UIScreen.main.bounds.width
            self.contentView.layer.addSublayer(playerLayer!)
            self.volumeView.layer.zPosition = 1
            player?.play()
            player?.isMuted = isMuted
            
        }
        
        self.updateLike(post: self.post!)
    }
    
    @IBAction func volumeButton_TouchUpInside(_ sender: UIButton) {
        if isMuted {
            isMuted = !isMuted
            volumeButton.setImage(UIImage(named: "Icon_Volume") , for: .normal)
        } else {
            isMuted = !isMuted
            volumeButton.setImage(UIImage(named: "Icon_Mute") , for: .normal)
        }
        player?.isMuted = isMuted
    }
    
    func updateLike(post: Post) {
        let imageName = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
        likeImageView.image = UIImage(named: imageName)
//                if post.likes == nil || !post.isLiked {
//                    likeImageView.image = UIImage(named: "like")
//                } else {
//                    likeImageView.image = UIImage(named: "likeSelected")
//                }
        
        guard let count = post.likeCount else {
            return
        }
        
        if count != 0 {
            likeCountButton.setTitle("\(count) likes", for: .normal)
        } else {
            likeCountButton.setTitle("Be the first to like this", for: .normal)
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
        
        let tapGestureForNameLabel = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        nameLabel.addGestureRecognizer(tapGestureForNameLabel)
        nameLabel.isUserInteractionEnabled = true
        
    }
    
    func nameLabel_TouchUpInside() {
        if let id = user?.id {
            delegate?.goToProfileUserVC(userId: id)
        }
    }
    
    func commentImageView_TouchUpInside() {
        if let id = post?.id {
            delegate?.goToCommentVC(postId: id)
        }
    }
    
    func likeImageView_TouchUpInside() {
        Api.Post.incrementLikes(postId: post!.id!, onSuccess: { (post) in
            self.updateLike(post: post)
            self.post?.likes = post.likes
            self.post?.isLiked = post.isLiked
            self.post?.likeCount = post.likeCount
        }) { (errorMessage) in
            SVProgressHUD.showError(withStatus: errorMessage)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        volumeView.isHidden = true
        profileImageView.image = UIImage(named: "ava")
        playerLayer?.removeFromSuperlayer()
        player?.pause()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
