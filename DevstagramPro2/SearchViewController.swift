//
//  SearchViewController.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 29/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchBar = UISearchBar()
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Search"
        searchBar.frame.size.width = view.frame.size.width - 60
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
        
        doSearch()
        
    }
    
    func doSearch() {
        if let searchText = searchBar.text?.lowercased() {
            self.users.removeAll()
            self.tableView.reloadData()
            Api.User.queryUser(withText: searchText, completion: { (user) in
                Api.Follow.isFollowing(userId: user.id!, completed: { (value) in
                    user.isFollowing = value
                    self.users.append(user)
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Search_ProfileSegue" {
            let profileVC = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            profileVC.userId = userId
            profileVC.delegate = self
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        doSearch()
    }
            //live search
//            func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//                doSearch()
//            }
    
}

extension SearchViewController: UITableViewDataSource {
    
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

extension SearchViewController: PeopleTableViewCellDelegate {
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Search_ProfileSegue", sender: userId)
    }
    
}

extension SearchViewController: HeaderProfileCollectionReusableViewDelegate {
    func updateFollowButton(forUser user: User) {
        for u in self.users {
            if user.id == user.id {
                u.isFollowing = user.isFollowing
                self.tableView.reloadData()
            }
        }
    }
    
}
