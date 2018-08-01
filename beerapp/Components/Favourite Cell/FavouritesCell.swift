//
//  FavsCell.swift
//  beerapp
//
//  Created by alex on 2/19/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit

import SDWebImage

class FavouritesCell: UITableViewCell {
    
    
    var commerce: Commerce? {
        didSet {
            setupCell()
        }
    }
    
    
    @IBOutlet weak var commerceNameLabel: UILabel!
    @IBOutlet weak var adresssLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    func setupCell() {
        
        commerceNameLabel.text = commerce?.name
        
        if let logo = commerce?.logo, let logoUrl = URL(string: logo) {
            logoImageView.sd_setImage(with: logoUrl, placeholderImage: #imageLiteral(resourceName: "icon-main-ilc"))
        }
        
        if let isFav = commerce?.isfavorite {
            closeButton.isSelected = isFav == "true"
        }
    }
    

    
}
