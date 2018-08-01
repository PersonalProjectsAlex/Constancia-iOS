//
//  customCell.swift
//  beerapp
//
//  Created by elaniin on 2/15/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import SDWebImage

class CheckInCell: UITableViewCell {
    var groups: Groups?{
        didSet {
            setupCell()
        }
    }
    
    var commerce: CoinsPerCommerce?{
        didSet {
            setupCellCommerce()
        }
    }
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var addressRestaurantLabel: UILabel!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    
    func setupCell() {
        
        restaurantNameLabel.text = groups?.name
        
        
    }
    
    func setupCellCommerce() {
        
        restaurantNameLabel.text = commerce?.name
         //addressRestaurantLabel.text = commerce?.
        
        if let coins = commerce?.coins {
            coinsLabel.text = "\(coins) coins"
        }
        
        if let address = commerce?.address {
            addressRestaurantLabel.text = address
        }
        
        if let image = commerce?.logo, let logo = URL(string: (commerce?.logo)!) {
            logoImageView.sd_setImage(with: logo, placeholderImage: #imageLiteral(resourceName: "icon-main-ilc"))
        }
        
    
    }
}
