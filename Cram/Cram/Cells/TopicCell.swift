//
//  TopicCell.swift
//  Cram
//
//  Created by Pablo Garces on 12/2/17.
//  Copyright © 2017 Cram. All rights reserved.
//

import UIKit

class TopicCell: UITableViewCell {
    
    
    @IBOutlet weak var topicImg: UIImageView!
    @IBOutlet weak var title: NSLayoutConstraint!
    @IBOutlet weak var topicTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        topicImg.layer.cornerRadius = 6
        topicImg.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
