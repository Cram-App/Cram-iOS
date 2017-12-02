//
//  LiveVC.swift
//  Cram
//
//  Created by Pablo Garces on 12/2/17.
//  Copyright © 2017 Cram. All rights reserved.
//

import UIKit

class LiveVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var liveCollectionView: UICollectionView!
    
    var friendLiveCount = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        liveCollectionView.dataSource = self
        liveCollectionView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Live Collection View
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "liveCell", for: indexPath) as! LiveCell
        cell.cellImg.image = UIImage(named: "samplevid")
        cell.cellBack.layer.masksToBounds = true
        cell.cellImg.layer.masksToBounds = true
        cell.cellBack.layer.cornerRadius = 6
        cell.cellImg.layer.cornerRadius = 6
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return friendLiveCount
    }

}
