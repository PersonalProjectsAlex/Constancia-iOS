//
//  PromotionCell.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/21/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit

class PromotionCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var promotion: Promotion? {
        didSet{
            setupCell(promotion: promotion!)
        }
    }
    
    func setupCell(promotion: Promotion) {
        
        nameLabel.text = promotion.name
        if let price = promotion.price {
            priceLabel.text = "$\(price)"
        }
        else {
            priceLabel.text = "$-.--"
        }
    }

}
