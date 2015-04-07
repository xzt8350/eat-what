//
//  PostTableViewCell.swift
//  ShareYourMeal
//
//  Created by Tracy on 4/6/15.
//  Copyright (c) 2015 Tracy. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet var foodPhoto: UIImageView!
    @IBOutlet var username: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
