//
//  CommentViewController.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 19/03/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    
}
