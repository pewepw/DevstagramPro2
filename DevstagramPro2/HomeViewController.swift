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

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        loadPosts()
        
    }
    
    func loadPosts() {
        FIRDatabase.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            print(snapshot.value)
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
}
