//
//  ShopCell.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/7/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit

class ShopCell: UITableViewCell {
    
    var commerce: Commerce?{
        didSet {
            setupCell()
        }
    }
    
    
    var coins: CoinsPerCommerce?{
        didSet {
            setupCell2()
        }
    }
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    var totalCoins = Int()
    
    func setupCell() {
        
        nameLabel.text = commerce?.name
        distanceLabel.text = String(format:"%.2f", (commerce?.distance?.toDouble()) ?? 0) + " km de tí"
        if let logo = commerce?.logo, let logoUrl = URL(string: logo) {
            logoImage.sd_setImage(with: logoUrl, placeholderImage: nil)
        }
    }
    
    func setupCell2() {
        
        nameLabel.text = coins?.name
        distanceLabel.text = (coins?.coins)! + " Monedas"
        if let logo = coins?.logo, let logoUrl = URL(string: logo) {
            logoImage.sd_setImage(with: logoUrl, placeholderImage: nil)
        }
    }
}
