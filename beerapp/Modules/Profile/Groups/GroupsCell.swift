//
//  GroupsCell.swift
//  beerapp
//
//  Created by alex on 2/26/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit

class GroupsCell: UITableViewCell {
    
    
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deleterowButton: UIButton!
    @IBOutlet weak var prefixLabel: UILabel!
    @IBOutlet weak var cellcontentView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 16, 0, 16))
    }
    
    
    
    
    
    
}

