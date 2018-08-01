//
//  HistoryHeaderCell.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 3/15/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit

class HistoryHeaderCell: UITableViewCell {
    
    var forPromo: Bool? {
        didSet{
            nameTitleLabel.text = forPromo! ? "Promocion" : "Premio"
        }
    }
    
    @IBOutlet weak var nameTitleLabel: UILabel!
    
}
