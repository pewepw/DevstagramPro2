//
//  PeopleViewController.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 26/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        loadUsers()
    }
    
    func loadUsers() {
        Api.User.observeUsers { (user) in
            self.isFollowing(userId: user.id!, completed: { (value) in
                user.isFollowing = value
                self.users.append(user)
                self.tableView.reloadData()
            })
        }
    }
    
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        Api.Follow.isFollowing(userId: userId, completed: completed)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSegue" {
            let profileVC = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            profileVC.userId = userId
            profileVC.delegate = self
        }
    }
}

extension PeopleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        let user = users[indexPath.row]
        cell.user = user
        cell.delegate = self
        return cell
    }
    
}

extension PeopleViewController: PeopleTableViewCellDelegate {
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "ProfileSegue", sender: userId)
    }
    
}

extension PeopleViewController: HeaderProfileCollectionReusableViewDelegate {
    func updateFollowButton(forUser user: User) {
        for u in self.users {
            if u.id == user.id {
                u.isFollowing = user.isFollowing
                self.tableView.reloadData()
            }
        }
    }
    
}
