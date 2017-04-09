//
//  FilterViewController.swift
//  DevstagramPro2
//
//  Created by Harry Ng on 09/04/2017.
//  Copyright © 2017 DevConcept. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var filterPhoto: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    @IBAction func cancelBtn_TouchUpInside(_ sender: Any) {
    }
    
    @IBAction func nextBtn_TouchUpInside(_ sender: Any) {
    }
    
}

extension FilterViewController: UICollectionViewDataSource, UICollectionViewDelegate {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        return cell
    }
}

