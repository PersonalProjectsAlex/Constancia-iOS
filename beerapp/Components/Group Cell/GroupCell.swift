//
//  GroupCell.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/16/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    var groups: Groups?{
        didSet {
            setupCell()
        }
    }
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var propertyLabel: UILabel!
    
    
    func setupCell() {
        if let name = groups?.name{
            nameLabel.text = name
        }
        
        if let members = groups?.members{
            membersLabel.text = members + " integrantes"
        }
        
        if let property = groups?.label{
            propertyLabel.text = property
        }
        
    }
}

