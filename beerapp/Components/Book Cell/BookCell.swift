//
//  BookCell.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/16/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import SDWebImage

class BookCell: UITableViewCell {
    
    var books: Reservations?{
        
        didSet {
            
            setupCell()
            
        }
        
    }
    
    
    @IBOutlet weak var commerceNameLabel: UILabel!
    
    @IBOutlet weak var adresssLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    
    
    func setupCell() {

        commerceNameLabel.text = books?.name
        adresssLabel.text = books?.commerceaddress
        groupLabel.text = "| " + (books?.groupname ?? "null")! + " | " + (books?.qty)! + " integrantes"

    }
}
