//
//  ClassCell.swift
//  Cram
//
//  Created by Pablo Garces on 12/2/17.
//  Copyright © 2017 Cram. All rights reserved.
//

import UIKit

class ClassCell: UITableViewCell {
    
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var friendAmount: UILabel!
    @IBOutlet weak var fBack1: UIView!
    @IBOutlet weak var fImg1: UIImageView!
    @IBOutlet weak var fBack2: UIView!
    @IBOutlet weak var fImg2: UIImageView!
    @IBOutlet weak var fBack3: UIView!
    @IBOutlet weak var fImg3: UIImageView!
    @IBOutlet weak var fBack4: UIView!
    @IBOutlet weak var fImg4: UIImageView!
    @IBOutlet weak var teacher: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        fBack1.layer.cornerRadius = fBack1.frame.size.width / 2
        fBack2.layer.cornerRadius = fBack2.frame.size.width / 2
        fBack3.layer.cornerRadius = fBack3.frame.size.width / 2
        fBack4.layer.cornerRadius = fBack4.frame.size.width / 2
        fImg1.layer.cornerRadius = fImg1.frame.size.width / 2
        fImg2.layer.cornerRadius = fImg2.frame.size.width / 2
        fImg3.layer.cornerRadius = fImg3.frame.size.width / 2
        fImg4.layer.cornerRadius = fImg4.frame.size.width / 2
        fImg1.layer.masksToBounds = true
        fImg2.layer.masksToBounds = true
        fImg3.layer.masksToBounds = true
        fImg4.layer.masksToBounds = true
        
        mainImg.layer.masksToBounds = true
        mainImg.layer.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
