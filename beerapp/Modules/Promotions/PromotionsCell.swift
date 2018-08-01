//
//  PromotionsCell.swift
//  beerapp
//
//  Created by elaniin on 2/21/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import SDWebImage

class PromotionsCell: UITableViewCell {

    var promotions: Promotion? {
        didSet{
            setupCell()
        }
    }
    
    @IBOutlet weak var promotionsImageView: UIImageView!
    @IBOutlet weak var detailPromotionLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 16, 0, 16))
    }
    
    func setupCell() {
        
        detailPromotionLabel.text = promotions?.name
        
        if let image = promotions?.image, let imageURL = URL(string: image) {
            promotionsImageView.sd_setImage(with: imageURL, placeholderImage: nil)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        promotionsImageView.image = nil
        
    }
    
}
