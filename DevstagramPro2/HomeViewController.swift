//
//  HomeViewController.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 13/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
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
